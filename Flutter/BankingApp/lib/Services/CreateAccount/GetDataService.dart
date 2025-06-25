import 'package:http/http.dart' as http;
import '../../Model/Account.dart';
import '../../Model/AuthService.dart';
import 'dart:convert';

class GetDataService {
  static const String baseUrl = 'http://10.0.2.2:3000/api/auth';

  static Future<GetAccountsResponse> getAccountsByUserId() async {
    final token = await AuthService.getToken();
    final userId = await AuthService.getCurrentUserId();
    print('In GetDataService - UserID: $userId, Token: ${token?.substring(0, 10)}...');

    if (token == null || userId == null) {
      return GetAccountsResponse(
        success: false,
        shouldLogout: true,
        message: 'User not authenticated',
      );
    }

    final url = Uri.parse('$baseUrl/getUserId/$userId');
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.get(
        url,
        headers: headers,
      ).timeout(const Duration(seconds: 10));

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        // The backend returns: { accounts: [...] }
        final List<Account> accounts = (responseData['accounts'] as List)
            .map((json) => Account.fromJson(json))
            .toList();

        return GetAccountsResponse(
          success: true,
          accounts: accounts,
          message: 'Accounts fetched successfully',
        );
      } else if (response.statusCode == 401) {
        return GetAccountsResponse(
          success: false,
          shouldLogout: true,
          message: 'Session expired',
        );
      } else {
        return GetAccountsResponse(
          success: false,
          message: responseData['message'] ?? 'Failed to fetch accounts',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      return GetAccountsResponse(
        success: false,
        message: 'Network error: ${e.toString()}',
        isNetworkError: true,
      );
    }
  }
}

class GetAccountsResponse {
  final bool success;
  final List<Account>? accounts;
  final String message;
  final bool shouldLogout;
  final int? statusCode;
  final bool isNetworkError;

  GetAccountsResponse({
    this.success = false,
    this.accounts,
    this.message = '',
    this.shouldLogout = false,
    this.statusCode,
    this.isNetworkError = false,
  });
}
