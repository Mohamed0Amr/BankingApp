// services/login_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Model/User.dart';

class LoginService {
  static const String baseUrl = 'https://bankingapp-production-62f3.up.railway.app';

  static String _getUserIdFromToken(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) throw Exception('Invalid token');

      final payload = parts[1];
      final normalized = base64Url.normalize(payload);
      final decoded = base64Url.decode(normalized);
      final payloadMap = json.decode(utf8.decode(decoded));

      return payloadMap['userId'].toString();
    } catch (e) {
      throw Exception('Failed to decode token: $e');
    }
  }

  static Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/api/auth/login');
    final headers = {"Content-Type": "application/json"};
    final body = json.encode({'username': username, 'password': password});

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final token = data['token'];
        final userId = _getUserIdFromToken(token);
        final user = User(
          id: userId,
          token: token,
          username: username,
          email: data['email'], // إذا رجع من السيرفر
        );

        return {
          'success': true,
          'user': user,
        };
      } else {
        final error = json.decode(response.body);
        return {
          'success': false,
          'message': error['message'] ?? 'Login failed',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: $e',
      };
    }
  }
}
