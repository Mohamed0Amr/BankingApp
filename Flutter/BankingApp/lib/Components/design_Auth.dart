import 'package:flutter/material.dart';

class designCard extends StatelessWidget {
  final Widget? formFields;
  final Widget? signUpPrompt;

  const designCard({
    Key? key,
    this.formFields,
    this.signUpPrompt,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'BankSystem',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 24.0),

              // Form fields section - customizable
              if (formFields != null) formFields!,

              SizedBox(height: 16.0),

              // Sign up prompt - customizable
              if (signUpPrompt != null) Center(child: signUpPrompt!),
            ],
          ),
        ),
      ),
    );
  }
}