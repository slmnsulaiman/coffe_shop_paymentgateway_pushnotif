// // const Checkout = require('../models/Checkout');

// // exports.createCheckout = async (req, res) => {
// //   try {
// //     const { userEmail, userName, items, total, metode } = req.body;

// //     const orderId = metode === 'Cash' ? `CASH-${Date.now()}` : null;
// //     const type = metode === 'Cash' ? 'bayar-kasir' : null;

// //     const newCheckout = new Checkout({
// //       userEmail,
// //       userName,
// //       items,
// //       orderId,
// //       total,
// //       metode,
// //       type,
// //       proses: 'proses',
// //       status: metode === 'Cash' ? 'success' : 'pending',
// //     });

// //     await newCheckout.save();

// //     res.status(201).json({
// //       message: 'Checkout berhasil dibuat',
// //       data: newCheckout,
// //     });
// //   } catch (err) {
// //     res.status(500).json({ message: 'Gagal membuat checkout', error: err.message });
// //   }
// // };


// // exports.updateProsesStatus = async (req, res) => {
// //   try {
// //     const { id } = req.params;

// //     const updated = await Checkout.findByIdAndUpdate(
// //       id,
// //       { proses: "selesai" },
// //       { new: true }
// //     );

// //     if (!updated) {
// //       return res.status(404).json({ message: "Transaksi tidak ditemukan" });
// //     }

// //     res.json({ message: "Status proses diperbarui ke selesai", data: updated });
// //   } catch (err) {
// //     res.status(500).json({ message: "Gagal update proses", error: err.message });
// //   }
// // };



// // // Ambil semua data checkout untuk admin
// // exports.getAllCheckout = async (req, res) => {
// //   try {
// //     const data = await Checkout.find().sort({ createdAt: -1 }); // urutkan terbaru dulu
// //     res.json(data);
// //   } catch (err) {
// //     console.error('Error getAllCheckout:', err);
// //     res.status(500).json({ message: 'Gagal mengambil data checkout' });
// //   }
// // };



// const Checkout = require('../models/Checkout');
// const User = require('../models/User');
// const sendFcmV1 = require('../utils/sendFcmV1');

// exports.createCheckout = async (req, res) => {
//   try {
//     const { userEmail, userName, items, total, metode } = req.body;

//     const orderId = metode === 'Cash' ? `CASH-${Date.now()}` : null;
//     const type = metode === 'Cash' ? 'bayar-kasir' : null;

//     const newCheckout = new Checkout({
//       userEmail,
//       userName,
//       items,
//       orderId,
//       total,
//       metode,
//       type,
//       proses: 'proses',
//       status: metode === 'Cash' ? 'success' : 'pending',
//     });

//     await newCheckout.save();

//     // ✅ Kirim notifikasi ke user jika status = success
//     const user = await User.findOne({ email: userEmail });
//     if (user?.fcmToken && newCheckout.status === 'success') {
//       await sendFcmV1(
//         user.fcmToken,
//         '✅ Pesanan Berhasil!',
//         'Pesanan Anda sedang diproses oleh kasir.'
//       );
//     }

//     res.status(201).json({
//       message: 'Checkout berhasil dibuat',
//       data: newCheckout,
//     });
//   } catch (err) {
//     res.status(500).json({ message: 'Gagal membuat checkout', error: err.message });
//   }
// };

// exports.updateProsesStatus = async (req, res) => {
//   try {
//     const { id } = req.params;

//     const updated = await Checkout.findByIdAndUpdate(
//       id,
//       { proses: "selesai" },
//       { new: true }
//     );

//     if (!updated) {
//       return res.status(404).json({ message: "Transaksi tidak ditemukan" });
//     }

//     // ✅ Kirim notifikasi ke user bahwa pesanan selesai
//     const checkout = await Checkout.findById(id);
//     const user = await User.findOne({ email: checkout.userEmail });

//     if (user?.fcmToken) {
//       await sendFcmV1(
//         user.fcmToken,
//         '☕ Pesanan Selesai!',
//         'Pesanan Anda telah selesai disiapkan oleh kasir.'
//       );
//     }

//     res.json({ message: "Status proses diperbarui ke selesai", data: updated });
//   } catch (err) {
//     res.status(500).json({ message: "Gagal update proses", error: err.message });
//   }
// };

// // Ambil semua data checkout untuk admin
// exports.getAllCheckout = async (req, res) => {
//   try {
//     const data = await Checkout.find().sort({ createdAt: -1 }); // urutkan terbaru dulu
//     res.json(data);
//   } catch (err) {
//     console.error('Error getAllCheckout:', err);
//     res.status(500).json({ message: 'Gagal mengambil data checkout' });
//   }
// };



const Checkout = require('../models/Checkout');
const User = require('../models/User');
const sendFcmV1 = require('../utils/sendFcmV1');



// 🧾 Buat checkout baru
exports.createCheckout = async (req, res) => {
  try {
    const { userEmail, userName, items, total, metode } = req.body;

    const orderId = metode === 'Cash' ? `CASH-${Date.now()}` : null;
    const type = metode === 'Cash' ? 'bayar-kasir' : null;

    const newCheckout = new Checkout({
      userEmail,
      userName,
      items,
      orderId,
      total,
      metode,
      type,
      proses: 'proses',
      status: metode === 'Cash' ? 'success' : 'pending',
    });

    await newCheckout.save();

    // ✅ Kirim notifikasi ke customer jika langsung success
    if (newCheckout.status === 'success') {
      const user = await User.findOne({ email: userEmail });
      if (user?.fcmToken) {
        await sendFcmV1(
          user.fcmToken,
          '✅ Pesanan Berhasil!',
          'Pesanan Anda sedang diproses oleh kasir.'
        );
      }
    }

  
    const kasirList = await User.find({ role: 'kasir', fcmToken: { $ne: null } });
    for (const kasir of kasirList) {
      await sendFcmV1(
        kasir.fcmToken,
        '📥 Pesanan Masuk!',
        'Ada pesanan baru dari pelanggan.',
        { type: 'new_order'  } ,
        'notifikasi_kasir'
        
        
      );
    }

    res.status(201).json({
      message: 'Checkout berhasil dibuat',
      data: newCheckout,
    });
  } catch (err) {
    res.status(500).json({
      message: 'Gagal membuat checkout',
      error: err.message,
    });
  }
};


// 🧾 Update proses ke 'selesai' + kirim notifikasi ke user
exports.updateProsesStatus = async (req, res) => {
  try {
    const { id } = req.params;

    const updated = await Checkout.findByIdAndUpdate(
      id,
      { proses: 'selesai' },
      { new: true }
    );

    if (!updated) {
      return res.status(404).json({ message: 'Transaksi tidak ditemukan' });
    }

    
    const user = await User.findOne({ email: updated.userEmail });

    if (user?.fcmToken) {
      await sendFcmV1(
        user.fcmToken,
        '☕ Pesanan Selesai!',
        'Pesanan Anda telah selesai disiapkan oleh kasir.',
        {},
        'notifikasi_custumer'
      
        
      );
    }

    res.json({
      message: 'Status proses diperbarui ke selesai',
      data: updated,
    });
  } catch (err) {
    res.status(500).json({
      message: 'Gagal update proses',
      error: err.message,
    });
  }
};

// 📦 Ambil semua checkout
exports.getAllCheckout = async (req, res) => {
  try {
    const data = await Checkout.find().sort({ createdAt: -1 });
    res.json(data);
  } catch (err) {
    console.error('Error getAllCheckout:', err);
    res.status(500).json({ message: 'Gagal mengambil data checkout' });
  }
};
