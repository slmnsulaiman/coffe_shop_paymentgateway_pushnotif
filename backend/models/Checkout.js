// // const mongoose = require('mongoose');

// // const checkoutSchema = new mongoose.Schema({
// //   userEmail: String,
// //   userName: String,
// //   items: [
// //     {
// //       productId: String,
// //       name: String,
// //       harga: Number,
// //       jumlah: Number,
// //     },
// //   ],
// //   total: Number,
// //   metode: String, // e.g. "Cash" atau "Midtrans"
// //   status: {
// //     type: String,
// //     default: 'pending', // atau 'success', 'failed'
// //   },
// //   createdAt: {
// //     type: Date,
// //     default: Date.now,
// //   },
// // });

// // module.exports = mongoose.model('Checkout', checkoutSchema);

// const mongoose = require('mongoose');

// const checkoutSchema = new mongoose.Schema({
//   userEmail: String,
//   userName: String,
//   items: [
//     {
//       productId: String,
//       name: String,
//       harga: Number,
//       jumlah: Number,
//     },
//   ],
//   total: Number,
//   metode: String, // e.g. "Cash" atau "Midtrans"
//   status: {
//     type: String,
//     enum: ['pending', 'success', 'failed'], // ✅ enum untuk validasi status
//     default: 'pending',
//   },
//   createdAt: {
//     type: Date,
//     default: Date.now,
//   },
// });

// module.exports = mongoose.model('Checkout', checkoutSchema);

const mongoose = require('mongoose');

const checkoutSchema = new mongoose.Schema({
  userEmail: String,
  userName: String,
  items: [
    {
      productId: String,
      name: String,
      harga: Number,
      jumlah: Number,
    },
  ],
  total: Number,
  metode: String,
  type: {
    type: String,
    default: null,
  }, 
  orderId: {
    type: String,
    unique: true,
  },
  status: {
    type: String,
    enum: ['pending', 'success', 'failed'],
    default: 'pending',
  },
  createdAt: {
    type: Date,
    default: Date.now,
  },
  proses: {
    type: String,
    default: "proses", // atau bisa null jika belum diproses
    enum: ["proses", "selesai"]
  }
});

module.exports = mongoose.model('Checkout', checkoutSchema);
