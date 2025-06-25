import 'package:bankingapp/Components/customButton.dart';
import 'package:bankingapp/Components/design_Auth.dart';
import 'package:bankingapp/Components/textField.dart';
import 'package:bankingapp/Services/check_username.dart';
import 'package:bankingapp/View/Auth/reset_password.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:bankingapp/Services/mail.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController _usernameController = TextEditingController();
  bool isLoading = false;
  String? email;
  String? generatedOtp;

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  // Generate 6-digit OTP
  String generateOtp() {
    var rng = Random();
    return (rng.nextInt(900000) + 100000).toString();
  }

  // Send OTP via email using your MailService
  Future<bool> sendOtpToEmail(String email, String otp) async {
    try {
      final result = await MailService.sendOtpEmail(email, otp);
      return result; // true if successful
    } catch (e) {
      print("Error sending email: $e");
      return false;
    }
  }

  // Handle OTP sending
  Future<void> sendOtp() async {
    setState(() {
      isLoading = true;
    });

    final username = _usernameController.text.trim();
    if (username.isEmpty) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Username is required')),
      );
      return;
    }

    final result = await CheckUsernameService.checkUsername(username: username);

    if (result['success']) {
      setState(() {
        email = result['data']['email'];
        generatedOtp = generateOtp();
      });

      final sendResult = await sendOtpToEmail(email!, generatedOtp!);

      if (sendResult) {
        setState(() {
          isLoading = false;
        });
        showOtpDialog();
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error sending OTP, please try again')),
        );
      }
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? 'Username not found')),
      );
    }
  }

  // OTP input popup
  void showOtpDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Enter OTP"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              OTPTextField(
                length: 6,
                onCompleted: (otp) {
                  if (otp == generatedOtp) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ResetPassword(),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Invalid OTP')),
                    );
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(7, 43, 99, 1.0),
      body: Center(
        child: designCard(
          formFields: Column(
            children: [
              CustomTextField(
                controller: _usernameController,
                hintText: 'Enter your username',
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: 'Back',
                      onPressed: () => Navigator.pop(context),
                      backgroundColor: Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: CustomButton(
                      text: 'Send OTP',
                      onPressed: isLoading ? null : sendOtp,
                      isLoading: isLoading,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
