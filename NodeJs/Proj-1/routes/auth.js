    const express = require('express');
    const router = express.Router();
    const { registerUser , loginUser , checkUsername , resetPassword, createAccount , getAccountsByUserId } = require('../controllers/authController');

    // Registration route
    router.post('/register', registerUser );

    // Login route
    router.post('/login', loginUser );

    // Login route
    router.post('/check', checkUsername );

    // Login route
    router.post('/reset', resetPassword );

    // CreateAccount route
    router.post('/createAccount', createAccount );

    // GetUserId route
    router.get('/getUserId/:userId', getAccountsByUserId );




    module.exports = router;