require('dotenv').config();
const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const morgan = require('morgan');
const http = require('http');
const { Server } = require('socket.io');

const authRoutes = require('./routes/auth.routes');
const userRoutes = require('./routes/user.routes');
const doctorRoutes = require('./routes/doctor.routes');
const consultationRoutes = require('./routes/consultation.routes');
const messageRoutes = require('./routes/message.routes');
const appointmentRoutes = require('./routes/appointment.routes');
const orderRoutes = require('./routes/order.routes');
const notificationRoutes = require('./routes/notification.routes');
const callRoutes = require('./routes/call.routes');
const aiRoutes = require('./routes/ai.routes');

const app = express();
const server = http.createServer(app);
const io = new Server(server, { cors: { origin: '*' } });

app.use(helmet());
app.use(cors());
app.use(morgan('dev'));
app.use(express.json());
app.set('io', io);

// WebSocket - مكالمات ومحادثة
io.on('connection', (socket) => {
  console.log('🔌 Connected:', socket.id);

  // الانضمام لغرفة المستخدم
  socket.on('join-user', (userId) => {
    socket.join('user-' + userId);
    console.log('👤 User joined:', userId);
  });

  // الانضمام لغرفة المكالمة
  socket.on('join-call', (consultationId) => {
    socket.join('call-' + consultationId);
    console.log('📞 Joined call room:', consultationId);
  });

  // مغادرة المكالمة
  socket.on('leave-call', (consultationId) => {
    socket.leave('call-' + consultationId);
    console.log('📴 Left call room:', consultationId);
  });

  // انضمام لاستشارة
  socket.on('join-consultation', (id) => {
    socket.join('consultation-' + id);
  });

  // إرسال رسالة
  socket.on('send-message', (data) => {
    io.to('consultation-' + data.consultation_id).emit('new-message', data);
  });

  socket.on('disconnect', () => {
    console.log('🔌 Disconnected:', socket.id);
  });
});

// Routes
app.use('/api/auth', authRoutes);
app.use('/api/user', userRoutes);
app.use('/api/doctors', doctorRoutes);
app.use('/api/consultations', consultationRoutes);
app.use('/api/messages', messageRoutes);
app.use('/api/appointments', appointmentRoutes);
app.use('/api/orders', orderRoutes);
app.use('/api/notifications', notificationRoutes);
app.use('/api/calls', callRoutes);
app.use('/api/ai', aiRoutes);

app.get('/health', (req, res) => res.json({ 
  status: 'ok', 
  service: 'Sehatak Backend v2.0',
  features: ['chat', 'calls', 'appointments', 'prescriptions', 'ai'],
  timestamp: new Date().toISOString() 
}));

const PORT = process.env.PORT || 3000;
server.listen(PORT, () => console.log(`🚀 Sehatak API running on port ${PORT} - Chat & Calls Ready`));
