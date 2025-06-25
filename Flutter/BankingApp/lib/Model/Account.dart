class Account {
  final int accountId;
  final int userId;
  final String accountNumber;
  final String accountType;
  final double balance;
  final DateTime createdAt;

  Account({
    required this.accountId,
    required this.userId,
    required this.accountNumber,
    required this.accountType,
    required this.balance,
    required this.createdAt,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      accountId: json['account_id'] as int,
      userId: json['user_id'] as int,
      accountNumber: json['account_number'] as String,
      accountType: json['account_type'] as String,
      balance: double.parse(json['balance'].toString()),
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  // Helper methods for display
  String get formattedBalance => '\$${balance.toStringAsFixed(2)}';

  String get displayType => accountType[0].toUpperCase() +
      accountType.substring(1).toLowerCase();

  String get maskedAccountNumber =>
      '****${accountNumber.substring(accountNumber.length - 4)}';
}