const express = require('express');
const app = express();
const authRoutes = require('./routes/auth');
require('dotenv').config(); // Load environment variables from .env file
// to connect with flutter
const cors = require('cors');
app.use(cors());


app.use(express.json()); // to read req.body

// Mount your auth routes
app.use('/api/auth', authRoutes);

const PORT = process.env.PORT || 3000; // Railway uses dynamic ports
app.listen(PORT, '0.0.0.0', () => {  // Listen on all network interfaces
  console.log(`Server running on port ${PORT}`);
});