const pool = require('../config/db');

const doctorController = {
  // قائمة الأطباء
  getAll: async (req, res) => {
    try {
      const { specialty, available } = req.query;
      let query = 'SELECT d.*, u.full_name, u.avatar FROM doctors d JOIN users u ON d.user_id = u.id WHERE 1=1';
      const params = [];
      if (specialty) { query += ' AND d.specialty = $' + (params.length + 1); params.push(specialty); }
      if (available) { query += ' AND d.is_available = true'; }
      const result = await pool.query(query, params);
      res.json({ success: true, data: result.rows });
    } catch (err) { res.status(500).json({ success: false, message: err.message }); }
  },

  // تفاصيل طبيب
  getById: async (req, res) => {
    try {
      const result = await pool.query('SELECT d.*, u.full_name, u.avatar FROM doctors d JOIN users u ON d.user_id = u.id WHERE d.id = $1', [req.params.id]);
      if (result.rows.length === 0) return res.status(404).json({ success: false, message: 'الطبيب غير موجود' });
      res.json({ success: true, data: result.rows[0] });
    } catch (err) { res.status(500).json({ success: false, message: err.message }); }
  },

  // تقييم طبيب
  rate: async (req, res) => {
    try {
      const { rating } = req.body;
      await pool.query('UPDATE doctors SET rating = (rating * reviews_count + $1) / (reviews_count + 1), reviews_count = reviews_count + 1 WHERE id = $2', [rating, req.params.id]);
      res.json({ success: true, message: 'تم التقييم بنجاح' });
    } catch (err) { res.status(500).json({ success: false, message: err.message }); }
  },

  // التخصصات
  specialties: async (req, res) => {
    try {
      const result = await pool.query('SELECT DISTINCT specialty FROM doctors');
      res.json({ success: true, data: result.rows.map(r => r.specialty) });
    } catch (err) { res.status(500).json({ success: false, message: err.message }); }
  }
};

module.exports = doctorController;
