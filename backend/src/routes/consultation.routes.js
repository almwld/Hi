const router = require('express').Router();
const { authenticate } = require('../middleware/auth.middleware');
const ctrl = require('../controllers/consultation.controller');
router.post('/', authenticate, ctrl.create);
router.get('/', authenticate, ctrl.getMy);
router.get('/:id', authenticate, ctrl.getById);
module.exports = router;
