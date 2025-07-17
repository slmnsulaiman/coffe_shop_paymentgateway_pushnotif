const express = require('express');
const router = express.Router();
const midtransController = require('../controller/midtransController');

router.post('/midtrans', midtransController.createTransaction);
// routes/midtransRoutes.js
router.post('/notification', midtransController.handleNotification);


module.exports = router;
