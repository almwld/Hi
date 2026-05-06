const router = require('express').Router();
const { authenticate } = require('../middleware/auth.middleware');
const ctrl = require('../controllers/call.controller');

router.post('/start', authenticate, ctrl.start);
router.post('/accept', authenticate, ctrl.accept);
router.post('/reject', authenticate, ctrl.reject);
router.post('/end', authenticate, ctrl.end);
router.get('/status/:consultation_id', authenticate, ctrl.status);

module.exports = router;
