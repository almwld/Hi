const pool = require('../config/db');

const messageController = {
  // إرسال رسالة
  send: async (req, res) => {
    try {
      const { consultation_id, content } = req.body;
      const result = await pool.query(
        'INSERT INTO messages (consultation_id, sender_id, content) VALUES ($1, $2, $3) RETURNING *',
        [consultation_id, req.user.id, content]
      );
      req.app.get('io').to('consultation-' + consultation_id).emit('new-message', result.rows[0]);
      res.status(201).json({ success: true, data: result.rows[0] });
    } catch (err) { res.status(500).json({ success: false, message: err.message }); }
  },

  // رسائل الاستشارة
  getByConsultation: async (req, res) => {
    try {
      const result = await pool.query(
        'SELECT m.*, u.full_name FROM messages m JOIN users u ON m.sender_id = u.id WHERE m.consultation_id = $1 ORDER BY m.sent_at',
        [req.params.id]
      );
      res.json({ success: true, data: result.rows });
    } catch (err) { res.status(500).json({ success: false, message: err.message }); }
  }
};

module.exports = messageController;
