const router = require('express').Router();
const { authenticate } = require('../middleware/auth.middleware');
const ctrl = require('../controllers/notification.controller');
router.get('/', authenticate, ctrl.getMy);
router.put('/:id/read', authenticate, ctrl.markRead);
module.exports = router;
