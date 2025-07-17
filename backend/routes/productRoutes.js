const express = require('express');
const router = express.Router();
const productController = require('../controller/productController');
const jwt = require('jsonwebtoken');
const upload = require('../middlewares/upload'); // ✅ Gunakan middleware upload

// Middleware token
const verifyToken = (req, res, next) => {
  const token = req.headers.authorization?.split(" ")[1];
  if (!token) return res.status(401).json({ message: 'Token tidak ditemukan' });

  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    // console.log("Decoded JWT:", decoded);
    req.user = decoded;
    next();
  } catch (err) {
    return res.status(403).json({ message: 'Token tidak valid' });
  }
};

// Middleware role admin
const onlyAdmin = (req, res, next) => {
  if (req.user.role !== 'admin') {
    return res.status(403).json({ message: 'Akses hanya untuk admin' });
  }
  next();
};

// ✅ Routes
router.get('/products', verifyToken, productController.getProducts);
router.post('/products', verifyToken, onlyAdmin, upload.single('foto'), productController.createProduct);
router.put('/products/:id', verifyToken, onlyAdmin, upload.single('foto'), productController.updateProduct);
router.delete('/products/:id', verifyToken, onlyAdmin, productController.deleteProduct);

module.exports = router;
