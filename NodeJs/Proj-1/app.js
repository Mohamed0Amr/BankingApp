require('dotenv').config(); // Fixed typo from 'tokenv' to 'dotenv'
const express = require('express'); // Fixed syntax
const app = express(); // Fixed variable name
const authRouter = require('./routes/auth');
const cors = require('cors'); // Fixed typo from 'core'

// 1. FIRST MIDDLEWARE - Add timing here
app.use((req, res, next) => {
  const start = Date.now();
  res.on('finish', () => {
    console.log(`${req.method} ${req.url} - ${Date.now() - start}ms`);
  });
  next();
});

// 2. Standard middleware
app.use(cors()); // Fixed from core()
app.use(express.urlencoded({ extended: true })); // Fixed syntax
app.use(express.json());

app.get('/', (req, res) => {
  res.send('✅ Banking App is running');
});

app.use((err, req, res, next) => {
  console.error('Unhandled error:', err.stack || err);
  res.status(500).json({ message: 'Internal server error' });
});


// 3. Routes
app.use('/api/auth', authRouter);

// 4. Server setup
const PORT = process.env.PORT || 3000;
app.listen(PORT, '0.0.0.0', () => {
  console.log(`Server running on port ${PORT}`); // Fixed template string
});