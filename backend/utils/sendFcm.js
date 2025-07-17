const axios = require('axios');

const sendFcm = async (token, title, body) => {
  try {
    const response = await axios.post(
      'https://fcm.googleapis.com/fcm/send',
      {
        to: token,
        notification: {
          title,
          body,
        },
      },
      {
        headers: {
          'Content-Type': 'application/json',
          Authorization: `key=${process.env.FCM_SERVER_KEY}`, // ⬅️ dari .env
        },
      }
    );

    console.log('✅ Notifikasi berhasil dikirim');
  } catch (err) {
    console.error('❌ Gagal kirim notifikasi:', err.response?.data || err.message);
  }
};

module.exports = sendFcm;
