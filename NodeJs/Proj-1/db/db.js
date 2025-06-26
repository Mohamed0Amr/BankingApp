require('dotenv').config();
const mysql = require('mysql2');

// Create the connection pool (better than single connection)
const pool = mysql.createPool({
  host: process.env.DB_HOST || 'localhost',
  user: process.env.DB_USER || 'root',
  password: process.env.DB_PASSWORD || 'MohamedAmr@2002',
  database: process.env.DB_NAME || 'bankingapp',
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0
});

// Verify connection
pool.getConnection((err, connection) => {
  if (err) {
    console.error('❌ DB connection failed:', err);
    return;
  }
  console.log('✅ Connected to MySQL database as root!');
  connection.release(); // Release the connection back to the pool
});

// Promisify for async/await support
const promisePool = pool.promise();

module.exports = {
  pool,
  promisePool
};