import 'package:bankingapp/View/HomePage/Dashboard.dart';
import 'package:flutter/material.dart';
import 'package:bankingapp/Components/customButton.dart';
import 'package:bankingapp/Components/textField.dart';
import 'package:bankingapp/View/Auth/forgot_password.dart';
import 'package:bankingapp/View/Auth/register.dart';
import 'package:bankingapp/Services/login_service.dart';

import '../../Components/design_Auth.dart';
import '../../Model/AuthService.dart';
import '../../Model/User.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _handleLogin() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      _showSnackBar('Please enter both username and password');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final result = await LoginService.login(
        username: username,
        password: password,
      );

      if (result['success'] == true) {
        final User user = result['user'];

        if (user.id == null || user.token == null) {
          throw Exception('Invalid authentication data received');
        }

        AuthService.setAuthData(user.id, user.token);
        _showSnackBar('Login successful!');

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => Dashboard(user: user)),
        );
      } else {
        _showSnackBar(result['message'] ?? 'Login failed');
      }

    } catch (e) {
      _showSnackBar('Login Error: ${e.toString()}');
      print('Login Error: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(7, 43, 99, 1.0),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: designCard(
              formFields: Column(
                children: [
                  CustomTextField(
                    controller: _usernameController,
                    hintText: 'Username',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _passwordController,
                    hintText: 'Password',
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    // prefixIcon: Icons.lock,
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ForgotPassword()),
                        );
                      },
                      child: const Text(
                        "Forgot Password?",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  CustomButton(
                    text: _isLoading ? "Processing..." : "Login",
                    onPressed: _isLoading ? null : _handleLogin,
                    backgroundColor: const Color.fromRGBO(7, 43, 99, 1.0),
                    textColor: Colors.white,
                  ),
                ],
              ),
              signUpPrompt: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RegisterScreen()),
                  );
                },
                child: const Text.rich(
                  TextSpan(
                    text: 'Don\'t have an account? ',
                    children: [
                      TextSpan(
                        text: 'Sign Up here',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}