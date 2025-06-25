import 'package:flutter/material.dart';

class AccountBalanceCard extends StatelessWidget {
  final bool balanceVisible;
  final VoidCallback onVisibilityChanged;
  final double totalBalance;
  final List<Map<String, dynamic>> accounts;

  const AccountBalanceCard({
    super.key,
    required this.balanceVisible,
    required this.onVisibilityChanged,
    required this.totalBalance,
    required this.accounts,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Balance',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      balanceVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.blue,
                    ),
                    onPressed: onVisibilityChanged,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                balanceVisible ? '\$${totalBalance.toStringAsFixed(2)}' : '••••••',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: accounts.map((account) => _AccountItem(
                  title: account['name'],
                  balance: account['balance'],
                  balanceVisible: balanceVisible,
                )).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AccountItem extends StatelessWidget {
  final String title;
  final double balance;
  final bool balanceVisible;

  const _AccountItem({
    required this.title,
    required this.balance,
    required this.balanceVisible,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          balanceVisible ? '\$${balance.toStringAsFixed(2)}' : '••••••',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
