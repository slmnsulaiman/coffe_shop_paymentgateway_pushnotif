// backend/models/User.js
const mongoose = require('mongoose');

const UserSchema = new mongoose.Schema({
  name: String,
  email: { type: String, unique: true },
  password: String,
  role: { type: String, default: 'customer' }, // default: customer
  fcmToken: { type: String },
}, { timestamps: true });

module.exports = mongoose.model('User', UserSchema);
