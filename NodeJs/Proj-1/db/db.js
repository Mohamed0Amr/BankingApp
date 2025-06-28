require('dotenv').config();
const mysql = require('mysql2');

const pool = mysql.createPool({
  host: process.env.MYSQLHOST || process.env.DB_HOST || 'localhost',
  user: process.env.MYSQLUSER || process.env.DB_USER || 'root',
  password: process.env.MYSQLPASSWORD || process.env.DB_PASSWORD || '',
  database: process.env.MYSQLDATABASE || process.env.DB_NAME || 'bankingapp',
  port: process.env.MYSQLPORT || process.env.DB_PORT || 3306,
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0,
  ssl: (process.env.DB_SSL || process.env.MYSQLSSL) ? { 
    rejectUnauthorized: false 
  } : null
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
console.log('DB Connection Config:', {
  host: process.env.MYSQLHOST || process.env.DB_HOST,
  user: process.env.MYSQLUSER || process.env.DB_USER,
  database: process.env.MYSQLDATABASE || process.env.DB_NAME,
  port: process.env.MYSQLPORT || process.env.DB_PORT
});

module.exports = pool.promise();