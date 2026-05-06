const router = require('express').Router();
const { authenticate } = require('../middleware/auth.middleware');
const ctrl = require('../controllers/doctor.controller');
router.get('/', authenticate, ctrl.getAll);
router.get('/specialties', authenticate, ctrl.specialties);
router.get('/:id', authenticate, ctrl.getById);
router.post('/:id/rate', authenticate, ctrl.rate);
module.exports = router;
