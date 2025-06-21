import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:do_an_mobile/utils/constants/api_constants.dart';

class AuthService {
  static const String baseUrl = '${ApiConstants.accountApi}/Login';
  static const String registerUrl = '${ApiConstants.accountApi}/Register';
  static const String userInfoUrl = '${ApiConstants.baseUrl}api/AccountApi/GetUserByEmail'; // 🔹 THÊM URL
  
  // Keys để lưu trong SharedPreferences
  static const String _isLoggedInKey = 'isLoggedIn';
  static const String _userEmailKey = 'userEmail';
  static const String _userNameKey = 'userName';
  static const String _userIdKey = 'userId';

  static Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'UserName': username, 'Password': password}),
    );
    
    print('Login URL: $baseUrl');
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      
      // Nếu đăng nhập thành công, gọi API khác để lấy thông tin user
      if (data['success'] == true) {
        try {
          // Gọi API để lấy thông tin user
          final userInfoResponse = await http.get(
            Uri.parse('${ApiConstants.baseUrl}api/AccountApi/GetUserInfo?username=$username'),
            headers: {'Content-Type': 'application/json'},
          );
          
          if (userInfoResponse.statusCode == 200) {
            final userInfo = jsonDecode(userInfoResponse.body);
            
            if (userInfo['success'] == true && userInfo['user'] != null) {
              final userData = userInfo['user'];
              
              String email = userData['email'] ?? '';
              String userName = userData['userName'] ?? username;
              String userId = userData['id']?.toString() ?? '';
              
              await _saveUserInfo(
                email: email,
                userName: userName,
                userId: userId,
              );
            }
          }
        } catch (e) {
          print('Error getting user info: $e');
          // Fallback: lưu ít nhất username
          await _saveUserInfo(
            email: username, // Có thể username là email
            userName: username,
            userId: DateTime.now().millisecondsSinceEpoch.toString(),
          );
        }
      }
      
      return data;
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
      final data = jsonDecode(response.body);
      
      // Có thể lưu thông tin user sau khi đăng ký thành công
      if (data['success'] == true) {
        await _saveUserInfo(
          email: email,
          userName: username,
          userId: data['userId']?.toString() ?? '',
        );
      }
      
      return data;
    } else {
      try {
        final data = jsonDecode(response.body);
        throw Exception(data['message'] ?? 'Register failed');
      } catch (e) {
        throw Exception('Register failed: ${response.body}');
      }
    }
  }

  // 🔹 THÊM METHOD getUserInfo
  static Future<Map<String, dynamic>> getUserInfo(String email) async {
    try {
      final response = await http.get(
        Uri.parse('$userInfoUrl?email=$email'),
        headers: {'Content-Type': 'application/json'},
      );
      
      print('GetUserInfo URL: $userInfoUrl?email=$email');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        return {
          'success': false,
          'message': 'Failed to get user info'
        };
      }
    } catch (e) {
      print('Error getting user info: $e');
      return {
        'success': false,
        'message': 'Network error: $e'
      };
    }
  }

  // Lưu thông tin user
  static Future<void> _saveUserInfo({
    required String email,
    required String userName,
    required String userId,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Lưu từng giá trị và kiểm tra
      final loginResult = await prefs.setBool(_isLoggedInKey, true);
      final emailResult = await prefs.setString(_userEmailKey, email);
      final userNameResult = await prefs.setString(_userNameKey, userName);
      final userIdResult = await prefs.setString(_userIdKey, userId);
      
      print('Save results - Login: $loginResult, Email: $emailResult, UserName: $userNameResult, UserId: $userIdResult');
      
      // Verify save ngay lập tức
      final savedLogin = prefs.getBool(_isLoggedInKey);
      final savedEmail = prefs.getString(_userEmailKey);
      final savedUserName = prefs.getString(_userNameKey);
      final savedUserId = prefs.getString(_userIdKey);
      
      print('Immediately after save - Login: $savedLogin, Email: $savedEmail, UserName: $savedUserName, UserId: $savedUserId');
      
    } catch (e) {
      print('Error saving user info: $e');
      rethrow;
    }
  }

  // Kiểm tra trạng thái đăng nhập
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  // Lấy email user
  static Future<String?> getCurrentUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userEmailKey);
  }

  // Lấy username
  static Future<String?> getCurrentUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userNameKey);
  }

  // Lấy user ID
  static Future<String?> getCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey);
  }

  // Lấy tất cả thông tin user
  static Future<Map<String, String?>> getCurrentUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'email': prefs.getString(_userEmailKey),
      'userName': prefs.getString(_userNameKey),
      'userId': prefs.getString(_userIdKey),
    };
  }

  // Đăng xuất
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_isLoggedInKey);
    await prefs.remove(_userEmailKey);
    await prefs.remove(_userNameKey);
    await prefs.remove(_userIdKey);
  }
}