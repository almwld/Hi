const { pool } = require('./db');
const bcrypt = require('bcryptjs');

async function seed() {
  try {
    const hash = await bcrypt.hash('123456', 12);

    // Users
    await pool.query(`INSERT INTO users (full_name, email, phone, password_hash, user_type, is_verified) VALUES
      ('أحمد محمد', 'ahmed@email.com', '+967777123456', $1, 'patient', true),
      ('د. علي المولد', 'ali@email.com', '+967777123457', $1, 'doctor', true),
      ('صيدلية الشفاء', 'pharmacy@email.com', '+967777123458', $1, 'pharmacy', true)
      ON CONFLICT (email) DO NOTHING`, [hash]);

    // Doctor
    await pool.query(`INSERT INTO doctors (user_id, specialty, license_number, experience_years, consultation_fee)
      VALUES ((SELECT id FROM users WHERE email='ali@email.com'), 'باطنية وأطفال', 'MD-001', 20, 500)
      ON CONFLICT DO NOTHING`);

    console.log('✅ Seed complete');
  } catch (err) { console.error('Seed error:', err); }
  process.exit();
}
seed();
