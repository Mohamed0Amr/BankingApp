import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionDetails extends StatelessWidget {
  final Map<String, dynamic> transaction;

  const TransactionDetails({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction['amount'] > 0;
    final dateFormat = DateFormat('MMM dd, yyyy - hh:mm a');

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: isIncome ? Colors.green[50] : Colors.red[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                transaction['icon'] as IconData,
                color: isIncome ? Colors.green : Colors.red,
                size: 30,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              '\$${transaction['amount'].abs().toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isIncome ? Colors.green : Colors.red,
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildDetailRow('Type', isIncome ? 'Credit' : 'Debit'),
          _buildDetailRow('Description', transaction['title'] as String),
          _buildDetailRow('Recipient', transaction['recipient'] as String),
          _buildDetailRow(
            'Date',
            dateFormat.format(transaction['date'] as DateTime),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[800],
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}