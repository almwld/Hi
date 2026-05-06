const pool = require('../config/db');

const consultationController = {
  // إنشاء استشارة
  create: async (req, res) => {
    try {
      const { doctor_id, symptoms, type } = req.body;
      const result = await pool.query(
        'INSERT INTO consultations (patient_id, doctor_id, symptoms, type, status) VALUES ($1, $2, $3, $4, $5) RETURNING *',
        [req.user.id, doctor_id, symptoms, type || 'text', 'pending']
      );
      res.status(201).json({ success: true, data: result.rows[0] });
    } catch (err) { res.status(500).json({ success: false, message: err.message }); }
  },

  // استشاراتي
  getMy: async (req, res) => {
    try {
      const result = await pool.query(
        'SELECT c.*, u.full_name as doctor_name FROM consultations c JOIN users u ON c.doctor_id = u.id WHERE c.patient_id = $1 ORDER BY c.created_at DESC',
        [req.user.id]
      );
      res.json({ success: true, data: result.rows });
    } catch (err) { res.status(500).json({ success: false, message: err.message }); }
  },

  // تفاصيل استشارة
  getById: async (req, res) => {
    try {
      const result = await pool.query('SELECT * FROM consultations WHERE id = $1', [req.params.id]);
      if (result.rows.length === 0) return res.status(404).json({ success: false, message: 'غير موجودة' });
      res.json({ success: true, data: result.rows[0] });
    } catch (err) { res.status(500).json({ success: false, message: err.message }); }
  }
};

module.exports = consultationController;
