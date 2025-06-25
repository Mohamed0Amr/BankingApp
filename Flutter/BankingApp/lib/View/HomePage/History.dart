import 'package:bankingapp/Components/History/summary_card.dart';
import 'package:bankingapp/Components/History/transaction_card.dart';
import 'package:bankingapp/Components/History/transaction_details.dart';
import 'package:bankingapp/Services/History/history_controller.dart';
import 'package:bankingapp/Components/History/filter_dialog.dart';
import 'package:flutter/material.dart';

import '../../Model/Account.dart';


class HistoryScreen extends StatefulWidget {
  final List<Account> accounts;

  const HistoryScreen({
    super.key,
    required this.accounts,
  });

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final _controller = HistoryController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction History'),
      ),
      body: widget.accounts.isEmpty
          ? const Center(child: Text('No accounts available'))
          : ListView.builder(
        itemCount: widget.accounts.length,
        itemBuilder: (context, index) {
          final account = widget.accounts[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: const Icon(Icons.history),
              title: Text(account.displayType),
              subtitle: Text(account.maskedAccountNumber),
              trailing: Text(
                account.formattedBalance,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              onTap: () {
                // Future feature: Navigate to detailed transaction screen
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Clicked ${account.accountNumber}')),
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _showTransactionDetails(BuildContext context, Map<String, dynamic> transaction) {
    showModalBottomSheet(
      context: context,
      builder: (context) => TransactionDetails(transaction: transaction),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const FilterDialog(),
    );
  }
}