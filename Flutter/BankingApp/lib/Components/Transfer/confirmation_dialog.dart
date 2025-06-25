import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  final String fromAccount;
  final String toAccount;
  final String amount;
  final String description;
  final VoidCallback onConfirm;

  const ConfirmationDialog({
    super.key,
    required this.fromAccount,
    required this.toAccount,
    required this.amount,
    required this.description,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Confirm Transfer'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('From:', fromAccount),
            _buildDetailRow('To:', toAccount),
            _buildDetailRow('Amount:', '\$$amount'),
            if (description.isNotEmpty)
              _buildDetailRow('Description:', description),
            const SizedBox(height: 16),
            const Text(
              'Are you sure you want to proceed?',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[800],
            foregroundColor: Colors.white,
          ),
          onPressed: () {
            onConfirm();
            Navigator.pop(context);
          },
          child: const Text('Confirm Transfer'),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}