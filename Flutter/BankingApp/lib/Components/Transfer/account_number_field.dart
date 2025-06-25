import 'package:flutter/material.dart';

class AccountNumberField extends StatelessWidget {
  final TextEditingController controller;

  const AccountNumberField({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'To Account Number',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: 'Enter recipient account number',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            filled: true,
            fillColor: Colors.grey[100],
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter an account number';
            }
            if (value.length < 8) {
              return 'Account number must be at least 8 digits';
            }
            if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
              return 'Only numbers are allowed';
            }
            return null;
          },
        ),
      ],
    );
  }
}