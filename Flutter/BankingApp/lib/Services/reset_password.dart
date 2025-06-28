import 'dart:convert';
import 'package:http/http.dart' as http;

class ResetPasswordService {
  static const String baseUrl = 'https://bankingapp-production-62f3.up.railway.app';

  static Future<Map<String, dynamic>> resetPassword({
    required String username,
    required String newPassword,
  }) async {
    final url = Uri.parse('$baseUrl/api/auth/reset-password');
    final headers = {"Content-Type": "application/json"};
    final body = json.encode({
      'username': username,
      'newPassword': newPassword,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {'success': true, 'message': data['message'] ?? 'Password reset successful'};
      } else {
        final error = json.decode(response.body);
        return {'success': false, 'message': error['message'] ?? 'Password reset failed'};
      }
    } catch (e) {
      return {'success': false, 'message': 'An error occurred: $e'};
    }
  }
}
