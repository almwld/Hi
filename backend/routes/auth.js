const express = require('express');
const router = express.Router();
const jwt = require('jsonwebtoken');

const JWT_SECRET = process.env.JWT_SECRET || 'sehatak_jwt_secret_2024_secure_key';

// POST /api/auth/login
router.post('/login', (req, res) => {
  const { phone, otp } = req.body;
  
  // قبول أي OTP للتطوير
  const token = jwt.sign({ phone }, JWT_SECRET, { expiresIn: '7d' });
  
  res.json({
    success: true,
    message: 'تم تسجيل الدخول بنجاح',
    token,
    user: { phone, name: 'مستخدم جديد' }
  });
});

// GET /api/auth/profile
router.get('/profile', (req, res) => {
  res.json({
    success: true,
    user: { phone: '+967770000000', name: 'مستخدم تجريبي' }
  });
});

module.exports = router;
