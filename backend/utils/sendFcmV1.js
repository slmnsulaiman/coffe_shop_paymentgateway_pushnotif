
const admin = require('firebase-admin');
const path = require('path');

// Inisialisasi hanya jika belum diinisialisasi
if (!admin.apps.length) {
  const serviceAccount = require(path.join(__dirname, '../service-account.json'));
  admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
  });
}

// Fungsi kirim notifikasi
// const sendFcmV1 = async (fcmToken, title, body, data = {}) => {
//   const message = {
//     notification: {
//       title,
//       body,
//     },
//     data, // 🔁 Data custom untuk client (Flutter)
//     token: fcmToken,
//   };

//   try {
//     const response = await admin.messaging().send(message);
//     console.log('✅ Notifikasi terkirim:', response);
//   } catch (error) {
//     console.error('❌ Gagal kirim notifikasi:', error.message);
//   }
// };

const sendFcmV1 = async (fcmToken, title, body, data = {}, sound = 'default') => {
  const message = {
    notification: {
      title,
      body,
    },
    data: {
      ...data,
      sound: sound, // ✅ Ini akan dikirim ke Flutter agar tahu nama sound-nya
    },
    android: {
      notification: {
        sound: sound, // ✅ Ini yang akan diputar di Android
      },
    },
    token: fcmToken,
  };

  try {
    const response = await admin.messaging().send(message);
    console.log('✅ Notifikasi terkirim:', response);
  } catch (error) {
    console.error('❌ Gagal kirim notifikasi:', error.message);
  }
};

module.exports = sendFcmV1;
