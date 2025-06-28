require('dotenv').config();
const mysql = require('mysql2');

const pool = mysql.createPool({
  host: process.env.MYSQLHOST || '127.0.0.1',
  user: process.env.MYSQLUSER || 'root',
  password: process.env.MYSQLPASSWORD || 'MohamedAmr@2002',
  database: process.env.MYSQLDATABASE || 'bankingapp',
  port: process.env.MYSQLPORT || 3306,
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0
});

// Debug logging
console.log('Railway DB Config:', {
  host: process.env.MYSQLHOST,
  user: process.env.MYSQLUSER,
  database: process.env.MYSQLDATABASE,
  port: process.env.MYSQLPORT
});

// Test connection
pool.getConnection((err, connection) => {
  if (err) {
    console.error('❌ DB connection failed:', err);
    console.log('Current DB Config:', {
      host: process.env.MYSQLHOST,
      user: process.env.MYSQLUSER,
      database: process.env.MYSQLDATABASE,
      port: process.env.MYSQLPORT
    });
    process.exit(1);
  }
  console.log('✅ DB connected successfully!');
  connection.release();
});

module.exports = pool.promise();