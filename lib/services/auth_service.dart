import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = 'http://localhost:5139/api/AccountApi/Login';
  static const String registerUrl = 'http://localhost:5139/api/AccountApi/Register';

  static Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'UserName': username, 'Password': password}),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      try {
        final data = jsonDecode(response.body);
        throw Exception(data['message'] ?? 'Login failed');
      } catch (e) {
        throw Exception('Login failed: ${response.body}');
      }
    }
  }

  static Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String phone,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse(registerUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'UserName': username,
        'Email': email,
        'PhoneNumber': phone,
        'Password': password,
      }),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      try {
        final data = jsonDecode(response.body);
        throw Exception(data['message'] ?? 'Register failed');
      } catch (e) {
        throw Exception('Register failed: ${response.body}');
      }
    }
  }
}