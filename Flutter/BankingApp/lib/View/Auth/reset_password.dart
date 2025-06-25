import 'package:bankingapp/Components/design_Auth.dart';
import 'package:flutter/material.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(7, 43, 99, 1.0),
      body: Center(
        child: designCard(
          formFields: Column(

          ),
        ),
      ),
    );
  }
}
