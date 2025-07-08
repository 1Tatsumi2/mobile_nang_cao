import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants/api_constants.dart';
import 'auth_service.dart';

class CouponService {
  static Future<Map<String, dynamic>> applyCoupon(String couponCode, double grandTotal) async {
    try {
      // 🔹 LẤY USER EMAIL TỪLOCALAUTH
      final userEmail = await AuthService.getCurrentUserEmail();
      if (userEmail == null) {
        return {
          'success': false,
          'error': 'Please login to apply coupon',
        };
      }

      final url = Uri.parse('${ApiConstants.baseUrl}api/CartApi/ApplyCoupon');
      
      final requestBody = {
        'couponCode': couponCode,
        'grandTotal': grandTotal,
        'userEmail': userEmail, // 🔹 THÊM USER EMAIL
      };
      
      print('🔹 APPLY COUPON REQUEST:');
      print('URL: $url');
      print('Request body: ${jsonEncode(requestBody)}');
      
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      print('🔹 APPLY COUPON RESPONSE:');
      print('Status code: ${response.statusCode}');
      print('Response headers: ${response.headers}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('🔹 SUCCESS: $data');
        return {
          'success': true,
          'data': data,
        };
      } else {
        final errorData = jsonDecode(response.body);
        print('🔹 ERROR: $errorData');
        return {
          'success': false,
          'error': errorData['message'] ?? 'Failed to apply coupon',
        };
      }
    } catch (e) {
      print('🔹 EXCEPTION in applyCoupon: $e');
      return {
        'success': false,
        'error': 'Network error: $e',
      };
    }
  }

  static Future<Map<String, dynamic>> removeCoupon() async {
    try {
      final url = Uri.parse('${ApiConstants.baseUrl}api/CartApi/RemoveCoupon');
      
      print('🔹 REMOVE COUPON REQUEST:');
      print('URL: $url');
      
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      print('🔹 REMOVE COUPON RESPONSE:');
      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'data': data,
        };
      } else {
        return {
          'success': false,
          'error': 'Failed to remove coupon',
        };
      }
    } catch (e) {
      print('🔹 EXCEPTION in removeCoupon: $e');
      return {
        'success': false,
        'error': 'Network error: $e',
      };
    }
  }
}