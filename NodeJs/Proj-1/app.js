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

const PORT = 3306;
app.listen(PORT, () => {
    console.log(`🚀 Server running at http://localhost:${PORT}`);
});