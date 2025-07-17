// backend/controllers/authController.js
const User = require('../models/User');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');

exports.register = async (req, res) => {
  const { name, email, password,role } = req.body;

  try {
    const existing = await User.findOne({ email });
    if (existing) return res.status(400).json({ message: 'Email sudah terdaftar' });

    const hashed = await bcrypt.hash(password, 10);
    const user = new User({
        name,
        email,
        password: hashed,
        role: role || 'customer', // jika tidak dikirim, default ke customer
      });
      

    await user.save();
    res.status(201).json({ message: 'Register berhasil' });
  } catch (err) {
    res.status(500).json({ message: 'Server error', error: err.message });
  }
};

// controllers/authController.js


exports.login = async (req, res) => {
    const { email, password } = req.body;

    try {
    const user = await User.findOne({ email });
    if (!user) return res.status(404).json({ message: 'User tidak ditemukan' });

    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) return res.status(400).json({ message: 'Password salah' });

    const token = jwt.sign(
        { id: user._id, role: user.role },
        process.env.JWT_SECRET,
        { expiresIn: '7d' }
    );

    res.status(200).json({
        message: 'Login berhasil',
        token,
        user: {
            id: user._id,
            name: user.name,
            email: user.email,
            role: user.role
        }
    });
    } catch (err) {
    res.status(500).json({ message: 'Server error', error: err.message });
    }
};

exports.saveFcmToken = async (req, res) => {
  try {
    const userId = req.user.id; // dari middleware auth
    const { token } = req.body;

    if (!token) {
      return res.status(400).json({ message: 'Token FCM tidak ditemukan' });
    }

    const updatedUser = await User.findByIdAndUpdate(
      userId,
      { fcmToken: token },
      { new: true }
    );

    res.status(200).json({
      message: 'FCM token berhasil disimpan',
      user: {
        id: updatedUser._id,
        name: updatedUser.name,
        email: updatedUser.email,
        fcmToken: updatedUser.fcmToken,
      },
    });
  } catch (err) {
    res.status(500).json({
      message: 'Gagal menyimpan FCM token',
      error: err.message,
    });
  }
};

exports.logout = async (req, res) => {
  try {
    const userId = req.user.id;

    // Set fcmToken jadi null saat logout
    await User.findByIdAndUpdate(userId, { fcmToken: null });

    res.status(200).json({ message: 'Logout berhasil dan FCM token dihapus' });
  } catch (err) {
    res.status(500).json({
      message: 'Gagal logout',
      error: err.message,
    });
  }
};


