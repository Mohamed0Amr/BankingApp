import 'package:bankingapp/Components/Transfer/account_number_field.dart';
import 'package:bankingapp/Components/Transfer/account_selector.dart';
import 'package:bankingapp/Components/Transfer/amount_field.dart';
import 'package:bankingapp/Components/Transfer/confirmation_dialog.dart';
import 'package:bankingapp/Components/Transfer/description_field.dart';
import 'package:bankingapp/Components/Transfer/transfer_button.dart';
import 'package:bankingapp/Services/Transfer/TransferController.dart';
import 'package:flutter/material.dart';

import '../../Model/Account.dart';


class TransferScreen extends StatefulWidget {
  final List<Account> accounts; // ✅ Moved above constructor

  const TransferScreen({
    super.key,
    required this.accounts, // ✅ Make it required
  });

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  final _controller = TransferController();


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transfer Money'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AccountSelector(
                value: _controller.selectedAccount,
                onChanged: (value) {
                  setState(() {
                    _controller.selectedAccount = value!;
                  });
                },
              ),
              const SizedBox(height: 20),
              AmountField(controller: _controller.amountController),
              const SizedBox(height: 20),
              AccountNumberField(controller: _controller.accountNumberController),
              const SizedBox(height: 20),
              DescriptionField(controller: _controller.descriptionController),
              const SizedBox(height: 30),
              TransferButton(
                onPressed: () => _showConfirmation(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showConfirmation(BuildContext context) {
    if (_controller.formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (context) => ConfirmationDialog(
          fromAccount: _controller.selectedAccount,
          toAccount: _controller.accountNumberController.text,
          amount: _controller.amountController.text,
          description: _controller.descriptionController.text,
          onConfirm: () => _controller.processTransfer(context),
        ),
      );
    }
  }
}