const pool = require('../config/db');
const bcrypt = require('bcryptjs');

const userController = {
  // تحديث الملف الشخصي
  updateProfile: async (req, res) => {
    try {
      const { full_name, email, phone } = req.body;
      await pool.query('UPDATE users SET full_name=$1, email=$2, phone=$3 WHERE id=$4', [full_name, email, phone, req.user.id]);
      res.json({ success: true, message: 'تم التحديث' });
    } catch (err) { res.status(500).json({ success: false, message: err.message }); }
  },

  // تغيير كلمة المرور
  changePassword: async (req, res) => {
    try {
      const { old_password, new_password } = req.body;
      const user = await pool.query('SELECT password_hash FROM users WHERE id=$1', [req.user.id]);
      const valid = await bcrypt.compare(old_password, user.rows[0].password_hash);
      if (!valid) return res.status(400).json({ success: false, message: 'كلمة المرور القديمة غير صحيحة' });
      const hash = await bcrypt.hash(new_password, 12);
      await pool.query('UPDATE users SET password_hash=$1 WHERE id=$2', [hash, req.user.id]);
      res.json({ success: true, message: 'تم تغيير كلمة المرور' });
    } catch (err) { res.status(500).json({ success: false, message: err.message }); }
  }
};

module.exports = userController;
