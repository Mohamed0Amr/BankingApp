import 'dart:convert';
import 'package:http/http.dart' as http;

class RegisterService {
  static const String baseUrl = 'https://bankingapp-production-62f3.up.railway.app';

  static Future<Map<String, dynamic>> register({
    required String username,
    required String password,
    required String email,
  }) async {
    final url = Uri.parse('$baseUrl/api/auth/register');
    final headers = {"Content-Type": "application/json"};
    final body = json.encode({
      'username': username,
      'password': password,
      'email': email,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {'success': true, 'data': data};
      } else {
        final error = json.decode(response.body);
        return {
          'success': false,
          'message': error['message'] ?? 'Register Failed',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'An error occurred: $e'};
    }
  }
}
