import 'dart:convert';
import 'package:http/http.dart' as http;

class CheckUsernameService {
  static const String baseUrl = 'http://10.0.2.2:3000/api/auth'; // Your base URL

  static Future<Map<String, dynamic>> checkUsername({
    required String username,
  }) async {
    final url = Uri.parse('$baseUrl/check');
    final headers = {"Content-Type": "application/json"};
    final body = json.encode({'username': username});

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {'success': true, 'data': data};
      } else {
        final error = json.decode(response.body);
        return {'success': false, 'message': error['message'] ?? 'Username check failed'};
      }
    } catch (e) {
      return {'success': false, 'message': 'An error occurred: $e'};
    }
  }
}
