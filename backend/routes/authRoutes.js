// backend/routes/authRoutes.js
const express = require('express');
const router = express.Router();
const authController = require('../controller/authController');
const verifyToken = require('../middlewares/authMiddleware');

router.post('/register', authController.register);
router.post('/login', authController.login);
router.post('/save-token', verifyToken, authController.saveFcmToken);
router.post('/logout', verifyToken, authController.logout);


module.exports = router;







