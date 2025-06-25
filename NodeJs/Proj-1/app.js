const express = require('express');
const app = express();
const authRoutes = require('./routes/auth');
require('dotenv').config(); // Load environment variables from .env file

app.use(express.json()); // to read req.body

// Mount your auth routes
app.use('/api/auth', authRoutes);

const PORT = 3000;
app.listen(PORT, () => {
    console.log(`🚀 Server running at http://localhost:${PORT}`);
});