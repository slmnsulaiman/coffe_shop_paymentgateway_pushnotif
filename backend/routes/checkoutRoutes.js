const express = require('express');
const router = express.Router();
const { createCheckout, getAllCheckout, updateProsesStatus } = require('../controller/checkoutController');

router.post('/checkout', createCheckout);
router.get('/checkout', getAllCheckout);
router.put('/checkout/:id/proses', updateProsesStatus);



module.exports = router;
