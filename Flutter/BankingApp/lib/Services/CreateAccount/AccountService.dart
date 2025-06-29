import 'package:http/http.dart' as http;
import '../../Model/Account.dart';
import '../../Model/AuthService.dart';
import 'dart:convert';

class AccountService {
  static const String baseUrl = 'https://bankingapp-production-62f3.up.railway.app';

  // Get the user ID
  static Future<List<Account>> getAccountsByUserId(int userId) async {
    final token = await AuthService.getToken();
    print('Fetching accounts for user $userId with token ${token?.substring(0, 10)}...');

    final response = await http.get(
      Uri.parse('$baseUrl/api/auth/getUserId/$userId'), // Include user ID in URL
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    ).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['accounts'] as List)
          .map((accountJson) => Account.fromJson(accountJson))
          .toList();
    } else if (response.statusCode == 401) {
      throw Exception('Session expired - Please login again');
    } else {
      throw Exception('Failed to load accounts: ${response.statusCode}');
    }
  }
  // Create Account
  static Future<AccountResponse> createAccount({
    required String accountType,
  }) async {
    final token = await AuthService.getToken();
    final userId = await AuthService.getCurrentUserId();
    print('In AccountService - UserID: $userId, Token: ${token?.substring(0, 10)}...');

    if (token == null || userId == null) {
      return AccountResponse(
        success: false,
        shouldLogout: true,
        message: 'User not authenticated',
      );
    }

    final url = Uri.parse('$baseUrl/api/auth/createAccount');
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    final body = json.encode({
      'account_type': accountType,
      'user_id': userId,
    });

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: body,
      ).timeout(const Duration(seconds: 10));

      final responseData = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        print(responseData);

        try {
          final account = Account.fromJson(responseData);
          return AccountResponse(
            success: true,
            account: account,
            message: responseData['message'] ?? 'Account created successfully',
          );
        } catch (e) {
          return AccountResponse(
            success: false,
            message: 'Invalid account data: ${e.toString()}',
          );
        }
      } else if (response.statusCode == 401) {
        return AccountResponse(
          success: false,
          shouldLogout: true,
          message: 'Session expired',
        );
      } else {
        return AccountResponse(
          success: false,
          message: responseData['message'] ?? 'Failed to create account',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      return AccountResponse(
        success: false,
        message: 'Network error: ${e.toString()}',
        isNetworkError: true,
      );
    }
  }
}

class AccountResponse {
  final bool success;
  final Account? account;
  final String message;
  final bool shouldLogout;
  final int? statusCode;
  final bool isNetworkError;

  AccountResponse({
    this.success = false,
    this.account,
    this.message = '',
    this.shouldLogout = false,
    this.statusCode,
    this.isNetworkError = false,
  });
}