const express = require('express');
const cors = require('cors');
const mongoose = require('mongoose');
const dotenv = require('dotenv');
dotenv.config();

// Import semua route
const authRoutes = require('./routes/authRoutes');
const userRoutes = require('./routes/userRoutes');
const productRoutes = require('./routes/productRoutes');
const checkoutRoutes = require('./routes/checkoutRoutes');
const midtransRoutes = require('./routes/midtransRoutes');




 // ✅ Tambahan baru

const app = express();
app.use(cors());
app.use(express.json());


// Routing
app.use('/api/auth', authRoutes);
app.use('/api', userRoutes); 
app.use('/api', productRoutes);
app.use('/api', checkoutRoutes);
app.use("/uploads", express.static("uploads"));
app.use("/api/uploads", express.static("uploads"));
app.use('/api', midtransRoutes);


// Koneksi MongoDB
mongoose.connect(process.env.MONGO_URL)
  .then(() => {
    console.log('MongoDB connected');
    app.listen(process.env.PORT || 5000, () => {
      console.log(`Server running on port ${process.env.PORT || 5000}`);
    });
  })
  .catch((err) => console.log(err));
