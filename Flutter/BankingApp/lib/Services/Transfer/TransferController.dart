import 'package:flutter/material.dart';

class TransferController {
  final formKey = GlobalKey<FormState>();
  String selectedAccount = 'Main Account';
  final amountController = TextEditingController();
  final accountNumberController = TextEditingController();
  final descriptionController = TextEditingController();

  void dispose() {
    amountController.dispose();
    accountNumberController.dispose();
    descriptionController.dispose();
  }

  void processTransfer(BuildContext context) {
    if (formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Transfer successful!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }
  }
}