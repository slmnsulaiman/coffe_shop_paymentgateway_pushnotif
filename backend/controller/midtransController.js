// // const midtransClient = require('midtrans-client');
// // const Checkout = require('../models/Checkout');

// // const snap = new midtransClient.Snap({
// //   isProduction: false,
// //   serverKey: process.env.MIDTRANS_SERVER_KEY, // dari .env
// // });

// // // Buat transaksi dan simpan ke MongoDB
// // exports.createTransaction = async (req, res) => {
// //   try {
// //     const { userName, userEmail, items, total, metode } = req.body;
// //     const orderId = 'ORDER-' + Date.now();

// //     const parameter = {
// //       transaction_details: {
// //         order_id: orderId,
// //         gross_amount: total,
// //       },
// //       customer_details: {
// //         first_name: userName,
// //         email: userEmail,
// //       },

// //     };


// //     const transaction = await snap.createTransaction(parameter);

// //     const newCheckout = new Checkout({
// //       userName,
// //       userEmail,
// //       items,
// //       total,
// //       metode,
// //       orderId,
// //       proses: 'proses', // ⬅️ baru
// //       status: 'pending',
// //     });

// //     await newCheckout.save();

// //     res.json({
// //       message: 'Snap token created',
// //       token: transaction.token,
// //       redirect_url: transaction.redirect_url,
// //     });
// //   } catch (err) {
// //     console.error('Midtrans Transaction Error:', err);
// //     res.status(500).json({ message: 'Gagal membuat transaksi Midtrans' });
// //   }
// // };



// // exports.handleNotification = async (req, res) => {
// //   console.log("⚡ MASUK KE /api/notification");
// //   try {
// //     const notif = req.body;
// //     const orderId = notif.order_id;
// //     const transactionStatus = notif.transaction_status;
// //     const paymentType = notif.payment_type; // ⬅️ ambil jenis payment

// //     console.log("🧾 Notifikasi dari Midtrans:", notif);

// //     let statusUpdate = 'pending';
// //     if (transactionStatus === 'settlement' || transactionStatus === 'capture') {
// //       statusUpdate = 'success';
// //     } else if (['deny', 'cancel', 'expire'].includes(transactionStatus)) {
// //       statusUpdate = 'failed';
// //     }

// //     const updated = await Checkout.findOneAndUpdate(
// //       { orderId },
// //       {
// //         status: statusUpdate,
// //         type: paymentType, // ⬅️ simpan jenis payment ke field baru
// //       },
// //       { new: true }
// //     );

// //     console.log("✅ Status diperbarui:", updated?.status);

// //     res.status(200).json({ message: 'Status updated' });
// //   } catch (err) {
// //     console.error('Notification Error:', err);
// //     res.status(500).json({ message: 'Notification handling failed', error: err.message });
// //   }
// // };


// const midtransClient = require('midtrans-client');
// const Checkout = require('../models/Checkout');
// const User = require('../models/User');
// const sendFcmV1 = require('../utils/sendFcmV1'); // pastikan ini diimport

// // MIDTRANS Snap client setup
// const snap = new midtransClient.Snap({
//   isProduction: false,
//   serverKey: process.env.MIDTRANS_SERVER_KEY,
// });

// // Membuat transaksi Midtrans dan menyimpan ke database
// exports.createTransaction = async (req, res) => {
//   try {
//     const { userName, userEmail, items, total, metode } = req.body;
//     const orderId = 'ORDER-' + Date.now();

//     const parameter = {
//       transaction_details: {
//         order_id: orderId,
//         gross_amount: total,
//       },
//       customer_details: {
//         first_name: userName,
//         email: userEmail,
//       },
//     };

//     const transaction = await snap.createTransaction(parameter);

//     const newCheckout = new Checkout({
//       userName,
//       userEmail,
//       items,
//       total,
//       metode,
//       orderId,
//       proses: 'proses',
//       status: 'pending',
//     });

//     await newCheckout.save();

//     res.json({
//       message: 'Snap token created',
//       token: transaction.token,
//       redirect_url: transaction.redirect_url,
//     });
//   } catch (err) {
//     console.error('Midtrans Transaction Error:', err);
//     res.status(500).json({ message: 'Gagal membuat transaksi Midtrans' });
//   }
// };

// // Menangani notifikasi dari Midtrans
// exports.handleNotification = async (req, res) => {
//   console.log("⚡ MASUK KE /api/notification");

//   try {
//     const notif = req.body;
//     const orderId = notif.order_id;
//     const transactionStatus = notif.transaction_status;
//     const paymentType = notif.payment_type;

//     console.log("🧾 Notifikasi dari Midtrans:", notif);

//     let statusUpdate = 'pending';
//     if (transactionStatus === 'settlement' || transactionStatus === 'capture') {
//       statusUpdate = 'success';
//     } else if (['deny', 'cancel', 'expire'].includes(transactionStatus)) {
//       statusUpdate = 'failed';
//     }

//     const updated = await Checkout.findOneAndUpdate(
//       { orderId },
//       {
//         status: statusUpdate,
//         type: paymentType,
//       },
//       { new: true }
//     );

//     console.log("✅ Status diperbarui:", updated?.status);

//     // ✅ Kirim notifikasi ke user kalau berhasil
//     if (updated && updated.status === 'success') {
//       const user = await User.findOne({ email: updated.userEmail });

//       if (user?.fcmToken) {
//         await sendFcmV1(
//           user.fcmToken,
//           '✅ Pembayaran Berhasil!',
//           'Pesanan kamu sedang diproses. Terima kasih!'
//         );
//       }
//     }

//     res.status(200).json({ message: 'Status updated' });
//   } catch (err) {
//     console.error('Notification Error:', err);
//     res.status(500).json({ message: 'Notification handling failed', error: err.message });
//   }
// };


const midtransClient = require('midtrans-client');
const Checkout = require('../models/Checkout');
const User = require('../models/User');
const sendFcmV1 = require('../utils/sendFcmV1');

// 🔧 Setup Midtrans Snap client
const snap = new midtransClient.Snap({
  isProduction: false,
  serverKey: process.env.MIDTRANS_SERVER_KEY,
});

// 📦 Buat transaksi Midtrans & simpan ke MongoDB
exports.createTransaction = async (req, res) => {
  try {
    const { userName, userEmail, items, total, metode } = req.body;
    const orderId = 'ORDER-' + Date.now();

    const parameter = {
      transaction_details: {
        order_id: orderId,
        gross_amount: total,
      },
      customer_details: {
        first_name: userName,
        email: userEmail,
      },
    };

    const transaction = await snap.createTransaction(parameter);

    const newCheckout = new Checkout({
      userName,
      userEmail,
      items,
      total,
      metode,
      orderId,
      proses: 'proses',
      status: 'pending',
    });

    await newCheckout.save();

    res.status(200).json({
      message: 'Snap token created',
      token: transaction.token,
      redirect_url: transaction.redirect_url,
    });
  } catch (err) {
    console.error('❌ Midtrans Transaction Error:', err);
    res.status(500).json({ message: 'Gagal membuat transaksi Midtrans' });
  }
};

// 🔔 Handle notifikasi Midtrans
exports.handleNotification = async (req, res) => {
  console.log('⚡ Menerima notifikasi dari Midtrans...');

  try {
    const notif = req.body;
    const orderId = notif.order_id;
    const transactionStatus = notif.transaction_status;
    const paymentType = notif.payment_type;

    console.log('📩 Isi Notifikasi:', notif);

    // Tentukan status berdasarkan notifikasi
    let statusUpdate = 'pending';
    if (transactionStatus === 'settlement' || transactionStatus === 'capture') {
      statusUpdate = 'success';
    } else if (['deny', 'cancel', 'expire'].includes(transactionStatus)) {
      statusUpdate = 'failed';
    }

    const updated = await Checkout.findOneAndUpdate(
      { orderId },
      { status: statusUpdate, type: paymentType },
      { new: true }
    );

    console.log('✅ Status transaksi diperbarui:', updated?.status);

    // ✅ Kirim notifikasi ke user jika transaksi sukses
    if (updated && updated.status === 'success') {
      const user = await User.findOne({ email: updated.userEmail });

      if (user?.fcmToken) {
        await sendFcmV1(
          user.fcmToken,
          '✅ Pembayaran Berhasil!',
          'Pesanan kamu sedang diproses. Terima kasih telah berbelanja!'
        );
      }
    }

    res.status(200).json({ message: 'Status updated' });
  } catch (err) {
    console.error('❌ Gagal menangani notifikasi Midtrans:', err);
    res.status(500).json({ message: 'Notification handling failed', error: err.message });
  }
};
