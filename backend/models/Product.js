const mongoose = require('mongoose');

const productSchema = new mongoose.Schema({
  name: {
    type: String,
    required: true,
  },
  harga: {
    type: Number,
    required: true,
  },
  deskripsi: {
    type: String,
    required: true,
  },
  foto: {
    type: String, // URL gambar
    required: true,
  },
}, { timestamps: true });

module.exports = mongoose.model('Product', productSchema);
