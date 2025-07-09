import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:do_an_mobile/utils/constants/api_constants.dart';

class AuthService {
  static const String baseUrl = '${ApiConstants.accountApi}/Login';
  static const String registerUrl = '${ApiConstants.accountApi}/Register';
  
  // Keys để lưu trong SharedPreferences
  static const String _isLoggedInKey = 'isLoggedIn';
  static const String _userEmailKey = 'user_email';
  static const String _userNameKey = 'user_name';
  static const String _userIdKey = 'user_id';
  static const String _userProfileKey = 'user_profile';

  static Future<Map<String, dynamic>> login(String username, String password) async {
    try {
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
        
        if (data['success'] == true && data['user'] != null) {
          final userData = data['user'];
          
          // 🔹 LƯU ĐẦY ĐỦ THÔNG TIN USER VÀO SHARED PREFERENCES
          await _saveUserInfo(userData);
          
          print('✅ User login successful and data saved');
          print('Saved user data: $userData');
          
          return data;
        }
      }
      
      return {
        'success': false,
        'message': 'Login failed'
      };
    } catch (e) {
      print('❌ Login error: $e');
      return {
        'success': false,
        'message': 'Network error: $e'
      };
    }
  }

  static Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
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
      
      print('Register URL: $registerUrl');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        if (data['success'] == true && data['user'] != null) {
          final userData = data['user'];
          
          // 🔹 LƯU THÔNG TIN USER SAU KHI ĐĂNG KÝ THÀNH CÔNG
          await _saveUserInfo(userData);
          
          print('✅ User register successful and data saved');
          return data;
        }
      }
      
      return {
        'success': false,
        'message': 'Register failed'
      };
    } catch (e) {
      print('❌ Register error: $e');
      return {
        'success': false,
        'message': 'Network error: $e'
      };
    }
  }

  // 🔹 THÊM METHOD getUserInfo
  static Future<Map<String, dynamic>> getUserInfo(String email) async {
    try {
      // Trước tiên, thử lấy từ cache
      final cachedProfile = await getCachedUserProfile();
      if (cachedProfile != null) {
        print('✅ Using cached user info');
        return {
          'success': true,
          'user': cachedProfile,
        };
      }

      // Nếu không có cache, gọi API
      print('🔄 Fetching user info from API for: $email');
      final response = await http.get(
        Uri.parse('${ApiConstants.accountApi}/GetProfile?email=$email'),
        headers: {'Content-Type': 'application/json'},
      );

      print('GetProfile Response status: ${response.statusCode}');
      print('GetProfile Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        if (data['success'] == true && data['user'] != null) {
          // Cập nhật cache
          await updateCachedProfile(data['user']);
          return data;
        }
      }
      
      return {
        'success': false,
        'message': 'Failed to get user info'
      };
    } catch (e) {
      print('❌ Error getting user info: $e');
      return {
        'success': false,
        'message': 'Network error: $e'
      };
    }
  }

  // 🔹 LƯU THÔNG TIN USER VÀO STORAGE
  static Future<void> _saveUserInfo(Map<String, dynamic> userData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Lưu từng giá trị cần thiết
      await prefs.setBool(_isLoggedInKey, true);
      await prefs.setString(_userEmailKey, userData['email'] ?? '');
      await prefs.setString(_userNameKey, userData['userName'] ?? '');
      await prefs.setString(_userIdKey, userData['id'] ?? '');
      
      // 🔹 LƯU TOÀN BỘ USER PROFILE VÀO CACHE
      await prefs.setString(_userProfileKey, jsonEncode(userData));
      
      print('✅ User info saved to SharedPreferences');
      print('Email: ${userData['email']}');
      print('UserName: ${userData['userName']}');
      print('Points: ${userData['points']}');
      print('MembershipTier: ${userData['membershipTier']}');
      
    } catch (e) {
      print('❌ Error saving user info: $e');
      rethrow;
    }
  }

  // 🔹 LẤY CACHED USER PROFILE
  static Future<Map<String, dynamic>?> getCachedUserProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedProfile = prefs.getString(_userProfileKey);
      
      if (cachedProfile != null) {
        return jsonDecode(cachedProfile);
      }
      return null;
    } catch (e) {
      print('Error getting cached profile: $e');
      return null;
    }
  }

  // 🔹 CẬP NHẬT CACHED PROFILE
  static Future<void> updateCachedProfile(Map<String, dynamic> userData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userProfileKey, jsonEncode(userData));
      print('✅ Updated cached profile');
    } catch (e) {
      print('❌ Error updating cached profile: $e');
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

  // 🔹 LẤY DISCOUNT RATE TỪ CACHED PROFILE
  static Future<double> getCurrentUserDiscountRate() async {
    try {
      final cachedProfile = await getCachedUserProfile();
      if (cachedProfile != null) {
        return (cachedProfile['discountRate'] as num?)?.toDouble() ?? 0.0;
      }
      return 0.0;
    } catch (e) {
      print('Error getting discount rate: $e');
      return 0.0;
    }
  }

  // 🔹 LẤY POINTS TỪ CACHED PROFILE
  static Future<int> getCurrentUserPoints() async {
    try {
      final cachedProfile = await getCachedUserProfile();
      if (cachedProfile != null) {
        return (cachedProfile['points'] as num?)?.toInt() ?? 0;
      }
      return 0;
    } catch (e) {
      print('Error getting points: $e');
      return 0;
    }
  }

  // 🔹 LẤY MEMBERSHIP TIER TỪ CACHED PROFILE
  static Future<String> getCurrentUserMembershipTier() async {
    try {
      final cachedProfile = await getCachedUserProfile();
      if (cachedProfile != null) {
        return cachedProfile['membershipTier'] ?? 'Basic';
      }
      return 'Basic';
    } catch (e) {
      print('Error getting membership tier: $e');
      return 'Basic';
    }
  }

  // Đăng xuất
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_isLoggedInKey);
    await prefs.remove(_userEmailKey);
    await prefs.remove(_userNameKey);
    await prefs.remove(_userIdKey);
    await prefs.remove(_userProfileKey);
    print('✅ User logged out and data cleared');
  }

  // 🔹 CLEAR CACHE (để force refresh)
  static Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userProfileKey);
    print('✅ User profile cache cleared');
  }

  // 🔹 THÊM FORGOT PASSWORD URL
  static const String forgotPasswordUrl = '${ApiConstants.accountApi}/ForgotPassword';
  static const String resetPasswordUrl = '${ApiConstants.accountApi}/ResetPassword';
  static const String verifyTokenUrl = '${ApiConstants.accountApi}/VerifyResetToken';

  // 🔹 API GỬI EMAIL FORGOT PASSWORD
  static Future<Map<String, dynamic>> forgotPassword(String email) async {
    try {
      print('🔄 Sending forgot password request for: $email');
      
      final response = await http.post(
        Uri.parse(forgotPasswordUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'Email': email}),
      );
      
      print('ForgotPassword URL: $forgotPasswordUrl');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        if (data['success'] == true) {
          print('✅ Forgot password email sent successfully');
          return {
            'success': true,
            'message': data['message'] ?? 'Password reset email sent successfully'
          };
        }
      }
      
      // Nếu không thành công, parse error message
      final errorData = jsonDecode(response.body);
      return {
        'success': false,
        'message': errorData['message'] ?? 'Failed to send reset email'
      };
    } catch (e) {
      print('❌ Forgot password error: $e');
      return {
        'success': false,
        'message': 'Network error: $e'
      };
    }
  }

  // 🔹 API RESET PASSWORD
  static Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String token,
    required String newPassword,
  }) async {
    try {
      print('🔄 Resetting password for: $email');
      
      final response = await http.post(
        Uri.parse(resetPasswordUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'Email': email,
          'Token': token,
          'NewPassword': newPassword,
        }),
      );
      
      print('ResetPassword URL: $resetPasswordUrl');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        if (data['success'] == true) {
          print('✅ Password reset successfully');
          return {
            'success': true,
            'message': data['message'] ?? 'Password reset successfully'
          };
        }
      }
      
      final errorData = jsonDecode(response.body);
      return {
        'success': false,
        'message': errorData['message'] ?? 'Failed to reset password',
        'errors': errorData['errors']
      };
    } catch (e) {
      print('❌ Reset password error: $e');
      return {
        'success': false,
        'message': 'Network error: $e'
      };
    }
  }

  // 🔹 API VERIFY RESET TOKEN
  static Future<Map<String, dynamic>> verifyResetToken({
    required String email,
    required String token,
  }) async {
    try {
      print('🔄 Verifying reset token for: $email');
      
      final response = await http.post(
        Uri.parse(verifyTokenUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'Email': email,
          'Token': token,
        }),
      );
      
      print('VerifyToken URL: $verifyTokenUrl');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        if (data['success'] == true) {
          print('✅ Token verified successfully');
          return data;
        }
      }
      
      final errorData = jsonDecode(response.body);
      return {
        'success': false,
        'message': errorData['message'] ?? 'Invalid token'
      };
    } catch (e) {
      print('❌ Verify token error: $e');
      return {
        'success': false,
        'message': 'Network error: $e'
      };
    }
  }

  // 🔹 THÊM CHANGE PASSWORD URL
  static const String changePasswordUrl = '${ApiConstants.accountApi}/ChangePassword';

  // 🔹 API ĐỔI MẬT KHẨU
  static Future<Map<String, dynamic>> changePassword({
    required String email,
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      print('🔄 Changing password for: $email');
      
      final response = await http.post(
        Uri.parse(changePasswordUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'Email': email,
          'CurrentPassword': currentPassword,
          'NewPassword': newPassword,
        }),
      );
      
      print('ChangePassword URL: $changePasswordUrl');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        if (data['success'] == true) {
          print('✅ Password changed successfully');
          return {
            'success': true,
            'message': data['message'] ?? 'Password changed successfully'
          };
        }
      }
      
      final errorData = jsonDecode(response.body);
      return {
        'success': false,
        'message': errorData['message'] ?? 'Failed to change password',
        'errors': errorData['errors']
      };
    } catch (e) {
      print('❌ Change password error: $e');
      return {
        'success': false,
        'message': 'Network error: $e'
      };
    }
  }
}