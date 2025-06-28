require('dotenv').config();
const mysql = require('mysql2');

const pool = mysql.createPool({
  host: process.env.DB_HOST || 'localhost',
  user: process.env.DB_USER || 'root',
  password: process.env.DB_PASSWORD || '',
  database: process.env.DB_NAME || 'bankingapp',
  port: process.env.DB_PORT || 3306,  // Fixed port number
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0,
  ssl: process.env.DB_SSL ? { rejectUnauthorized: false } : null
});

// Test connection
pool.getConnection((err, connection) => {
  if (err) {
    console.error('❌ DB connection failed:', err);
    process.exit(1);
  }
  console.log('✅ DB connected successfully!');
  connection.release();
});

module.exports = pool.promise();