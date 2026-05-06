require('dotenv').config();
const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const morgan = require('morgan');
const http = require('http');
const socketIO = require('socket.io');

const app = express();
const server = http.createServer(app);
const io = socketIO(server, { cors: { origin: '*' } });

// Middleware
app.use(helmet());
app.use(cors());
app.use(morgan('combined'));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.set('io', io);

// ========== Routes ==========
app.use('/api/otp', require('./routes/otp'));
app.use('/api/auth', require('./routes/auth'));
app.use('/api/chat', require('./routes/chat'));
app.use('/api/appointments', require('./routes/appointments'));
app.use('/api/pharmacy', require('./routes/pharmacy'));
app.use('/api/labs', require('./routes/labs'));
app.use('/api/payments', require('./routes/payments'));
app.use('/api/reviews', require('./routes/reviews'));

// Health Check
app.get('/health', (req, res) => {
  res.json({ status: 'online', service: 'منصة صحتك', version: '4.0.0' });
});

// WebSocket
io.on('connection', (socket) => {
  console.log('✅ User connected:', socket.id);
  socket.on('disconnect', () => console.log('❌ User disconnected:', socket.id));
});

const PORT = process.env.PORT || 3000;
server.listen(PORT, () => console.log(`🚀 Server running on port ${PORT}`));

// ==========================================
// منع نوم Render - Self Ping كل 10 دقائق
// ==========================================
const http = require('http');
const PING_INTERVAL = 10 * 60 * 1000; // 10 دقائق

const selfPing = () => {
  const port = process.env.PORT || 3000;
  http.get(`http://localhost:${port}/health`, (res) => {
    const now = new Date().toLocaleTimeString('ar-YE');
    console.log(`🔄 [${now}] Self-ping: ${res.statusCode} - Render awake ✅`);
  }).on('error', (e) => {
    console.log(`⚠️ Self-ping failed: ${e.message}`);
  });
};

// تشغيل كل 10 دقائق
setInterval(selfPing, PING_INTERVAL);

// أول ping بعد 5 دقائق من التشغيل
setTimeout(selfPing, 5 * 60 * 1000);

console.log('🟢 Anti-sleep: Self-ping enabled (every 10 minutes)');
