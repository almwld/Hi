const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const pool = require('../config/db');
const whatsappService = require('../services/whatsapp.service');
const { JWT_SECRET } = require('../middleware/auth.middleware');

const authController = {
  // طلب OTP
  requestOTP: async (req, res) => {
    try {
      const { phone } = req.body;
      if (!phone) return res.status(400).json({ success: false, message: 'يرجى إدخال رقم الهاتف' });
      
      const result = await whatsappService.sendOTP(phone);
      res.json(result);
    } catch (err) { res.status(500).json({ success: false, message: err.message }); }
  },

  // تحقق OTP + تسجيل/دخول
  verifyOTP: async (req, res) => {
    try {
      const { phone, otp } = req.body;
      const verification = whatsappService.verifyOTP(phone, otp);
      if (!verification.success) return res.status(400).json(verification);

      // البحث عن المستخدم أو إنشاؤه
      let user = await pool.query('SELECT * FROM users WHERE phone = $1', [phone]);
      
      if (user.rows.length === 0) {
        // إنشاء مستخدم جديد
        const hash = await bcrypt.hash(phone, 10); // كلمة مرور مؤقتة = رقم الهاتف
        user = await pool.query(
          "INSERT INTO users (full_name, phone, password_hash, user_type, is_verified) VALUES ($1, $2, $3, 'patient', true) RETURNING *",
          ['مستخدم جديد', phone, hash]
        );
      } else {
        // تحديث التحقق
        await pool.query('UPDATE users SET is_verified = true WHERE id = $1', [user.rows[0].id]);
      }

      const token = jwt.sign({ id: user.rows[0].id, role: user.rows[0].user_type }, JWT_SECRET, { expiresIn: '30d' });
      res.json({ success: true, token, user: { id: user.rows[0].id, full_name: user.rows[0].full_name, phone: user.rows[0].phone } });
    } catch (err) { res.status(500).json({ success: false, message: err.message }); }
  },

  // تسجيل تقليدي
  register: async (req, res) => {
    try {
      const { full_name, email, phone, password, user_type } = req.body;
      const existing = await pool.query('SELECT id FROM users WHERE phone = $1 OR email = $2', [phone, email]);
      if (existing.rows.length > 0) return res.status(400).json({ success: false, message: 'رقم الهاتف أو البريد مسجل مسبقاً' });

      const hash = await bcrypt.hash(password, 12);
      const result = await pool.query(
        'INSERT INTO users (full_name, email, phone, password_hash, user_type) VALUES ($1,$2,$3,$4,$5) RETURNING id, full_name, phone, user_type',
        [full_name, email, phone, hash, user_type || 'patient']
      );

      const token = jwt.sign({ id: result.rows[0].id, role: result.rows[0].user_type }, JWT_SECRET, { expiresIn: '30d' });
      res.status(201).json({ success: true, token, user: result.rows[0] });
    } catch (err) { res.status(500).json({ success: false, message: err.message }); }
  },

  // دخول
  login: async (req, res) => {
    try {
      const { email, password } = req.body;
      const result = await pool.query('SELECT * FROM users WHERE email = $1 OR phone = $1', [email]);
      if (result.rows.length === 0) return res.status(401).json({ success: false, message: 'بيانات الدخول غير صحيحة' });

      const user = result.rows[0];
      const valid = await bcrypt.compare(password, user.password_hash);
      if (!valid) return res.status(401).json({ success: false, message: 'بيانات الدخول غير صحيحة' });

      const token = jwt.sign({ id: user.id, role: user.user_type }, JWT_SECRET, { expiresIn: '30d' });
      delete user.password_hash;
      res.json({ success: true, token, user });
    } catch (err) { res.status(500).json({ success: false, message: err.message }); }
  },

  getProfile: async (req, res) => {
    try {
      const result = await pool.query('SELECT id, full_name, email, phone, user_type, avatar, created_at FROM users WHERE id = $1', [req.user.id]);
      if (result.rows.length === 0) return res.status(404).json({ success: false, message: 'غير موجود' });
      res.json({ success: true, data: result.rows[0] });
    } catch (err) { res.status(500).json({ success: false, message: err.message }); }
  }
};

module.exports = authController;
