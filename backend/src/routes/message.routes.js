const router = require('express').Router();
const { authenticate } = require('../middleware/auth.middleware');
const ctrl = require('../controllers/message.controller');
router.post('/', authenticate, ctrl.send);
router.get('/:id', authenticate, ctrl.getByConsultation);
module.exports = router;
