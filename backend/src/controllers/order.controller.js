const pool = require('../config/db');

const orderController = {
  // طلب جديد
  create: async (req, res) => {
    try {
      const { pharmacy_id, items, total_amount } = req.body;
      const result = await pool.query(
        'INSERT INTO orders (user_id, pharmacy_id, total_amount, items) VALUES ($1,$2,$3,$4) RETURNING *',
        [req.user.id, pharmacy_id, total_amount, JSON.stringify(items)]
      );
      res.status(201).json({ success: true, data: result.rows[0] });
    } catch (err) { res.status(500).json({ success: false, message: err.message }); }
  },

  // طلباتي
  getMy: async (req, res) => {
    try {
      const result = await pool.query('SELECT * FROM orders WHERE user_id = $1 ORDER BY created_at DESC', [req.user.id]);
      res.json({ success: true, data: result.rows });
    } catch (err) { res.status(500).json({ success: false, message: err.message }); }
  }
};

module.exports = orderController;
