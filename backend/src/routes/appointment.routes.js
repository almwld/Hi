const router = require('express').Router();
const { authenticate } = require('../middleware/auth.middleware');
const ctrl = require('../controllers/appointment.controller');
router.post('/', authenticate, ctrl.create);
router.get('/', authenticate, ctrl.getMy);
router.delete('/:id', authenticate, ctrl.cancel);
module.exports = router;
