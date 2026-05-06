const callService = require('../services/call.service');
const pool = require('../config/db');

const callController = {
  // بدء مكالمة
  start: async (req, res) => {
    try {
      const { consultation_id, call_type } = req.body;
      
      // التحقق من الاستشارة
      const consultation = await pool.query('SELECT * FROM consultations WHERE id = $1', [consultation_id]);
      if (consultation.rows.length === 0) {
        return res.status(404).json({ success: false, message: 'الاستشارة غير موجودة' });
      }

      const { token, channel, appId } = callService.startCall(
        consultation_id, 
        req.user.id, 
        consultation.rows[0].doctor_id, 
        call_type || 'audio'
      );

      // إرسال إشعار للطرف الآخر عبر WebSocket
      req.app.get('io').to('user-' + consultation.rows[0].doctor_id).emit('incoming-call', {
        consultation_id,
        caller: req.user.full_name || 'مريض',
        call_type,
        channel
      });

      res.json({ success: true, data: { token, channel, appId } });
    } catch (err) { res.status(500).json({ success: false, message: err.message }); }
  },

  // قبول مكالمة
  accept: async (req, res) => {
    try {
      const { consultation_id } = req.body;
      const result = callService.acceptCall(consultation_id, req.user.id);
      if (!result) return res.status(404).json({ success: false, message: 'المكالمة غير موجودة' });
      
      req.app.get('io').to('call-' + consultation_id).emit('call-accepted', { consultation_id });
      res.json({ success: true, data: result });
    } catch (err) { res.status(500).json({ success: false, message: err.message }); }
  },

  // رفض مكالمة
  reject: async (req, res) => {
    try {
      const { consultation_id } = req.body;
      callService.endCall(consultation_id);
      req.app.get('io').to('call-' + consultation_id).emit('call-rejected', { consultation_id });
      res.json({ success: true, message: 'تم رفض المكالمة' });
    } catch (err) { res.status(500).json({ success: false, message: err.message }); }
  },

  // إنهاء مكالمة
  end: async (req, res) => {
    try {
      const { consultation_id } = req.body;
      callService.endCall(consultation_id);
      req.app.get('io').to('call-' + consultation_id).emit('call-ended', { consultation_id });
      res.json({ success: true, message: 'تم إنهاء المكالمة' });
    } catch (err) { res.status(500).json({ success: false, message: err.message }); }
  },

  // حالة المكالمة
  status: async (req, res) => {
    try {
      const status = callService.getCallStatus(req.params.consultation_id);
      res.json({ success: true, data: status });
    } catch (err) { res.status(500).json({ success: false, message: err.message }); }
  }
};

module.exports = callController;
