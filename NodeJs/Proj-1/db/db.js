// const dotenv = require('dotenv').config(); // Not needed for local
const mysql = require('mysql2');

// Direct config for local MySQL
const pool = mysql.createPool({
  host: 'localhost',
  user: 'root',
  password: 'MohamedAmr@2002',           // or 'your-local-password'
  database: 'bankingapp',  // replace with your local DB name
  port: 3306,
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0,
  connectTimeout: 10000 // 10 second timeout
});

// Test connection
pool.getConnection((err, connection) => {
  if (err) {
    console.error('❌ DB Connection Error:', err);
    process.exit(1);
  }
  console.log('✅ DB Connected. Thread ID:', connection.threadId);
  connection.release();
});

module.exports = pool.promise();





// require('dotenv').config();
// const mysql = require('mysql2');

// console.log('Checking ENV variables:', {
//   MYSQLHOST: process.env.MYSQLHOST ? 'exists' : 'missing',
//   MYSQLUSER: process.env.MYSQLUSER ? 'exists' : 'missing',
//   MYSQLPASSWORD: process.env.MYSQLPASSWORD ? 'exists' : 'missing'
// });

// const pool = mysql.createPool({
//   host: process.env.MYSQLHOST, // mysql.railway.internal
//   user: process.env.MYSQLUSER, // root
//   password: process.env.MYSQLPASSWORD, // HogFBLyMTextoXQXwPvADEYsBDejNJNg
//   database: process.env.MYSQLDATABASE, // railway
//   port: process.env.MYSQLPORT || 3306,
//   waitForConnections: true,
//   connectionLimit: 10,
//   queueLimit: 0,
//   connectTimeout: 10000 // 10 second timeout
// });
// // Test connection
// // In your db.js, add this debug code:
// pool.getConnection((err, connection) => {
//   if (err) {
//     console.error('❌ DB Connection Error:', err);
//     process.exit(1);
//   }
//   console.log('✅ DB Connected. Thread ID:', connection.threadId);
//   connection.release();
// });

// module.exports = pool.promise();