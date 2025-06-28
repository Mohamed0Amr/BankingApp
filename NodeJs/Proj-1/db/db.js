require('dotenv').config();
const mysql = require('mysql2');

const pool = mysql.createPool({
  host: process.env.DB_HOST  , // Will use 'mysql.railway.internal' in Railway
  user: process.env.DB_USER ,
  password: process.env.DB_PASSWORD,
  database: process.env.MYSQLDATABASE || process.env.DB_NAME, // Note: Railway uses 'railway' as default DB
  port: process.env.DB_PORT,
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0
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