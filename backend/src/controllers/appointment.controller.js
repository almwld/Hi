const pool = require('../config/db');

const appointmentController = {
  // حجز موعد
  create: async (req, res) => {
    try {
      const { doctor_id, appointment_date, appointment_time, type, notes } = req.body;
      const result = await pool.query(
        'INSERT INTO appointments (patient_id, doctor_id, appointment_date, appointment_time, type, notes) VALUES ($1,$2,$3,$4,$5,$6) RETURNING *',
        [req.user.id, doctor_id, appointment_date, appointment_time, type || 'in_person', notes]
      );
      res.status(201).json({ success: true, data: result.rows[0] });
    } catch (err) { res.status(500).json({ success: false, message: err.message }); }
  },

  // مواعيدي
  getMy: async (req, res) => {
    try {
      const result = await pool.query(
        'SELECT a.*, u.full_name as doctor_name FROM appointments a JOIN users u ON a.doctor_id = u.id WHERE a.patient_id = $1 ORDER BY a.appointment_date',
        [req.user.id]
      );
      res.json({ success: true, data: result.rows });
    } catch (err) { res.status(500).json({ success: false, message: err.message }); }
  },

  // إلغاء موعد
  cancel: async (req, res) => {
    try {
      await pool.query("UPDATE appointments SET status = 'cancelled' WHERE id = $1 AND patient_id = $2", [req.params.id, req.user.id]);
      res.json({ success: true, message: 'تم الإلغاء' });
    } catch (err) { res.status(500).json({ success: false, message: err.message }); }
  }
};

module.exports = appointmentController;
