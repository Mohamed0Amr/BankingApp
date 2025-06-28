const jwt = require('jsonwebtoken');
const db = require('../db/db'); // assuming db.js connects and exports mysql
const bcrypt = require('bcryptjs');
const crypto = require('crypto');
const nodemailer = require('nodemailer');


// Register User Function
const registerUser = async (req, res) => {
  const { username, password, email } = req.body;

  if (!username || !password || !email) {
    return res.status(400).json({ message: 'All fields are required' });
  }

  try {
    const hashedPassword = bcrypt.hashSync(password, 10);

    const [result] = await db.query(
      'INSERT INTO Users (username, password_hash, email) VALUES (?, ?, ?)',
      [username, hashedPassword, email]
    );

    res.status(201).json({ message: 'User registered successfully!' });
  } catch (err) {
    if (err.code === 'ER_DUP_ENTRY') {
      return res.status(409).json({ message: 'Username or email already exists' });
    }
    console.error('Registration error:', err);
    return res.status(500).json({ error: err.message });
  }
};


// Login User Function
const loginUser = async (req, res) => {
  const { username, password } = req.body;

  if (!username || !password) {
    return res.status(400).json({ message: 'All fields are required' });
  }

  try {
    const [results] = await db.query('SELECT * FROM Users WHERE username = ?', [username]);

    if (results.length === 0) {
      return res.status(401).json({ message: 'Invalid credentials' });
    }

    const user = results[0];
    const isPasswordValid = bcrypt.compareSync(password, user.password_hash);

    if (!isPasswordValid) {
      return res.status(401).json({ message: 'Invalid credentials' });
    }

    const token = jwt.sign({ userId: user.user_id }, process.env.JWT_SECRET, { expiresIn: '1h' });

    res.json({ token });
  } catch (err) {
    console.error('Login error:', err);
    res.status(500).json({ message: 'Server error' });
  }
};

// CheckUsername Function
const checkUsername = (req, res) => {
    const { username } = req.body;

    if (!username) {
        return res.status(400).json({ message: 'Username is required' });
    }

    // Log the username to check if it's coming through properly
    console.log('Checking username:', username);

    // Query the database to find the user by username
    db.query('SELECT email FROM Users WHERE username = ?', [username], (err, results) => {
        if (err) {
            console.error('Database error:', err);  // Log the actual error
            return res.status(500).json({ message: 'Database error' });
        }

        // If no results are found, return a 404 response
        if (results.length === 0) {
            console.log('Username not found');
            return res.status(404).json({ message: 'Username not found' });
        }

        // If a matching username is found, return the email
        const email = results[0].email;
        console.log('Email found:', email);
        res.json({ email });
    });
};


// ResetPassword Function
const resetPassword = (req, res) => {
    const { username, newPassword } = req.body;

    if (!username || !newPassword) {
        return res.status(400).json({ message: 'Username and new password are required' });
    }

    // Hash the new password before storing it (use bcrypt or any other hashing method)
    const hashedPassword = bcrypt.hashSync(newPassword, 10);

    // Update the user's password in the database
    db.query('UPDATE Users SET password_hash = ? WHERE username = ?', [hashedPassword, username], (err, results) => {
        if (err) {
            return res.status(500).json({ message: 'Database error' });
        }

        if (results.affectedRows === 0) {
            return res.status(404).json({ message: 'Username not found' });
        }

        res.json({ message: 'Password updated successfully' });
    });
};

// Create Account Function
const createAccount = (req, res) => {
    const { user_id, account_type } = req.body;

    if (!user_id || !account_type) {
        return res.status(400).json({ message: 'user_id and account_type are required' });
    }

    // إنشاء رقم حساب عشوائي
    const account_number = 'AC' + Math.floor(100000000 + Math.random() * 900000000);
    const balance = 500;
    const created_at = new Date();

    db.query(
        'INSERT INTO accounts (user_id, account_number, account_type, balance, created_at) VALUES (?, ?, ?, ?, ?)',
        [user_id, account_number, account_type, balance, created_at],
        (err, results) => {
            if (err) {
                console.error('Database error:', err);
                return res.status(500).json({ message: 'Database error' });
            }

            res.status(201).json({
                message: 'Account created successfully',
                account_number,
                account_type,
                balance,
            });
        }
    );
};
// Get the UserID
const getAccountsByUserId = (req, res) => {
    const userId = req.params.userId;

    if (!userId) {
        return res.status(400).json({ message: 'user_id is required' });
    }

    db.query('SELECT * FROM accounts WHERE user_id = ?', [userId], (err, results) => {
        if (err) {
            console.error('Database error:', err);
            return res.status(500).json({ message: 'Database error' });
        }

        res.status(200).json({ accounts: results });
    });
};





module.exports = { registerUser , loginUser , resetPassword , checkUsername , createAccount ,getAccountsByUserId };
