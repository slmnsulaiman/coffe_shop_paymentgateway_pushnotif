const Product = require('../models/Product');
const fs = require('fs');
const path = require('path');

// CREATE
// CREATE
exports.createProduct = async (req, res) => {
    try {
      const { name, harga, deskripsi } = req.body;
      const foto = req.file ? `/uploads/${req.file.filename}` : '';
  
      const product = new Product({ name, harga, deskripsi, foto });
      await product.save();
  
      res.status(201).json({ message: 'Produk berhasil ditambahkan' });
    } catch (err) {
      res.status(500).json({ message: 'Gagal menambahkan produk', error: err.message });
    }
  };
  

// READ
exports.getProducts = async (req, res) => {
  try {
    const products = await Product.find().sort({ createdAt: -1 });
    res.status(200).json({ products });
  } catch (err) {
    res.status(500).json({ message: 'Gagal mengambil data produk', error: err.message });
  }
};

// UPDATE
exports.updateProduct = async (req, res) => {
  try {
    const { id } = req.params;
    const { name, harga, deskripsi } = req.body;

    const existing = await Product.findById(id);
    if (!existing) return res.status(404).json({ message: 'Produk tidak ditemukan' });

    // Hapus file lama jika ada file baru
    if (req.file && existing.foto) {
      const oldPath = path.join(__dirname, '..', existing.foto);
      if (fs.existsSync(oldPath)) {
        fs.unlinkSync(oldPath);
      }
    }

    const updatedData = {
      name,
      harga,
      deskripsi,
      foto: req.file ? `/uploads/${req.file.filename}` : existing.foto,
    };

    await Product.findByIdAndUpdate(id, updatedData);
    res.status(200).json({ message: 'Produk berhasil diupdate' });
  } catch (err) {
    res.status(500).json({ message: 'Gagal update produk', error: err.message });
  }
};

// DELETE
exports.deleteProduct = async (req, res) => {
  try {
    const { id } = req.params;
    const product = await Product.findByIdAndDelete(id);

    if (!product) return res.status(404).json({ message: 'Produk tidak ditemukan' });

    // Hapus file foto dari sistem
    if (product.foto) {
      const filePath = path.join(__dirname, '..', product.foto);
      if (fs.existsSync(filePath)) {
        fs.unlinkSync(filePath);
      }
    }

    res.status(200).json({ message: 'Produk berhasil dihapus' });
  } catch (err) {
    res.status(500).json({ message: 'Gagal hapus produk', error: err.message });
  }
};
