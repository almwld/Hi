const router = require('express').Router();
const { authenticate } = require('../middleware/auth.middleware');
const ctrl = require('../controllers/order.controller');
router.post('/', authenticate, ctrl.create);
router.get('/', authenticate, ctrl.getMy);
module.exports = router;
