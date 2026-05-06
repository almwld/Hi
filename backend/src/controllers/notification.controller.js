const pool = require('../config/db');

const notificationController = {
  // إشعاراتي
  getMy: async (req, res) => {
    try {
      const result = await pool.query('SELECT * FROM notifications WHERE user_id = $1 ORDER BY created_at DESC LIMIT 20', [req.user.id]);
      res.json({ success: true, data: result.rows });
    } catch (err) { res.status(500).json({ success: false, message: err.message }); }
  },

  // تعيين كمقروء
  markRead: async (req, res) => {
    try {
      await pool.query('UPDATE notifications SET is_read = true WHERE id = $1 AND user_id = $2', [req.params.id, req.user.id]);
      res.json({ success: true, message: 'تم' });
    } catch (err) { res.status(500).json({ success: false, message: err.message }); }
  }
};

module.exports = notificationController;
