const { Pool } = require('pg');

const pool = new Pool({
  host: process.env.DB_HOST || 'localhost',
  port: process.env.DB_PORT || 5432,
  database: process.env.DB_NAME || 'sehatak',
  user: process.env.DB_USER || 'test_user',
  password: process.env.DB_PASS || 'test_pass',
  max: 10,
  idleTimeoutMillis: 30000,
});

pool.on('error', (err) => {
  console.error('DB Error:', err.message);
});

module.exports = pool;
