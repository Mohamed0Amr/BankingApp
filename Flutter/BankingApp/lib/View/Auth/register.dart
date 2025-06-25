import 'package:flutter/material.dart';
import 'package:bankingapp/Components/customButton.dart';
import 'package:bankingapp/Components/textField.dart';
import 'package:bankingapp/Components/design_Auth.dart';
import 'package:bankingapp/Services/register_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  bool isPasswordMatch = true;
  bool isConfirmPasswordNotEmpty = false; // ✅ جديد لمراقبة كتابة المستخدم

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _fullNameController.dispose();
    super.dispose();
  }

  void _clearFields() {
    _emailController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
    _fullNameController.clear();
    setState(() {
      isPasswordMatch = true;
      isConfirmPasswordNotEmpty = false;
    });
  }

  Future<void> _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      final result = await RegisterService.register(
        username: _fullNameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      _clearFields();
    }
  }

  void _checkPasswordMatch(String value) {
    setState(() {
      isConfirmPasswordNotEmpty = value.isNotEmpty;
      isPasswordMatch = _passwordController.text.trim() == value.trim();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(7, 43, 99, 1.0),
      body: Center(
        child: SingleChildScrollView(
          child: designCard(
            formFields: Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    controller: _fullNameController,
                    hintText: 'Full Name',
                  ),
                  SizedBox(height: 16),
                  CustomTextField(
                    controller: _emailController,
                    hintText: 'Email',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 16),
                  CustomTextField(
                    controller: _passwordController,
                    hintText: 'Password',
                    obscureText: true,
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          controller: _confirmPasswordController,
                          hintText: 'Confirm Password',
                          obscureText: true,
                          onChanged: (value) {
                            _checkPasswordMatch(value);
                          },
                        ),
                      ),
                      SizedBox(width: 10),
                      if (isConfirmPasswordNotEmpty) // ✅ تظهر الأيقونة فقط لما يكتب
                        Icon(
                          isPasswordMatch ? Icons.check_circle_outline : Icons
                              .cancel,
                          color: isPasswordMatch ? Colors.green : Colors.red,
                        ),
                    ],
                  ),
                  SizedBox(height: 24),
                  CustomButton(
                    text: "Register",
                    onPressed: _handleRegister,
                    backgroundColor: Color.fromRGBO(7, 43, 99, 1.0),
                  ),
                ],
              ),
            ),
            signUpPrompt: TextButton(
              onPressed: () {
                Navigator.pop(context); // Go back to login
              },
              child: Text.rich(
                TextSpan(
                  text: 'Already have an account? ',
                  children: [
                    TextSpan(
                      text: 'Login',
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
    );
  }
}
