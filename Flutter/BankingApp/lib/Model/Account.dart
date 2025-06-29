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
      accountId: json['account_id'] ?? 0,
      userId: json['user_id'] ?? 0,
      accountNumber: json['account_number'] ?? '',
      accountType: json['account_type'] ?? '',
      balance: double.tryParse(json['balance'].toString()) ?? 0.0,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }


  // Helper methods for display
  String get formattedBalance => '\$${balance.toStringAsFixed(2)}';

  String get displayType => accountType[0].toUpperCase() +
      accountType.substring(1).toLowerCase();

  String get maskedAccountNumber =>
      '****${accountNumber.substring(accountNumber.length - 4)}';
}