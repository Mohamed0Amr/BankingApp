import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RecentTransactions extends StatelessWidget {
  final List<Map<String, dynamic>> transactions;
  final VoidCallback onViewAll;
  final Function(Map<String, dynamic>) onTransactionTap;

  const RecentTransactions({
    super.key,
    required this.transactions,
    required this.onViewAll,
    required this.onTransactionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Transactions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: onViewAll,
                child: const Text('View All'),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                ...transactions.map((transaction) => TransactionItem(
                  title: transaction['title'] as String,
                  amount: transaction['amount'] as double,
                  date: transaction['date'] as DateTime,
                  icon: transaction['icon'] as IconData,
                  onTap: () => onTransactionTap(transaction),
                )),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class TransactionItem extends StatelessWidget {
  final String title;
  final double amount;
  final DateTime date;
  final IconData icon;
  final VoidCallback onTap;

  const TransactionItem({
    super.key,
    required this.title,
    required this.amount,
    required this.date,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.blue),
      ),
      title: Text(title),
      subtitle: Text(
        DateFormat('MMM dd, hh:mm a').format(date),
      ),
      trailing: Text(
        '\$${amount.abs().toStringAsFixed(2)}',
        style: TextStyle(
          color: amount < 0 ? Colors.red : Colors.green,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: onTap,
    );
  }
}