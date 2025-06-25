import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryController {
  final List<Map<String, dynamic>> transactions = [
    {
      'id': '1',
      'title': 'Grocery Store',
      'amount': -85.50,
      'date': DateTime.now().subtract(const Duration(hours: 2)),
      'type': 'expense',
      'icon': Icons.shopping_cart,
      'recipient': 'Supermarket Inc.'
    },
    {
      'id': '2',
      'title': 'Salary Deposit',
      'amount': 2500.00,
      'date': DateTime.now().subtract(const Duration(days: 1)),
      'type': 'income',
      'icon': Icons.account_balance,
      'recipient': 'Company XYZ'
    },
  ];

  double get totalIncome => transactions
      .where((t) => t['amount'] > 0)
      .fold(0.0, (sum, t) => sum + t['amount']);

  double get totalExpenses => transactions
      .where((t) => t['amount'] < 0)
      .fold(0.0, (sum, t) => sum + t['amount']);

  double get netBalance => totalIncome + totalExpenses;

  String formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  String formatTime(DateTime date) {
    return DateFormat('hh:mm a').format(date);
  }
}