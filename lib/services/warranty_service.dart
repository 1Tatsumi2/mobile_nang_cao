import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:do_an_mobile/utils/constants/api_constants.dart';

class WarrantyService {
  static const String getUserWarrantiesUrl = '${ApiConstants.accountApi}/GetUserWarranties';
  static const String requestWarrantyUrl = '${ApiConstants.accountApi}/RequestWarranty';
  static const String cancelWarrantyUrl = '${ApiConstants.accountApi}/CancelWarranty';

  // 🔹 LẤY DANH SÁCH WARRANTY CỦA USER
  static Future<List<Map<String, dynamic>>> getUserWarranties(String email) async {
    try {
      print('🔄 Getting user warranties for: $email');
      
      final response = await http.get(
        Uri.parse('$getUserWarrantiesUrl?email=$email'),
        headers: {'Content-Type': 'application/json'},
      );
      
      print('GetUserWarranties URL: $getUserWarrantiesUrl');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        if (data['success'] == true) {
          return List<Map<String, dynamic>>.from(data['warranties']);
        }
      }
      
      return [];
    } catch (e) {
      print('❌ Get user warranties error: $e');
      return [];
    }
  }

  // 🔹 TẠO WARRANTY REQUEST
  static Future<Map<String, dynamic>> requestWarranty({
    required String email,
    required String warrantyCode,
    required String reason,
  }) async {
    try {
      print('🔄 Requesting warranty for: $email, code: $warrantyCode');
      
      final response = await http.post(
        Uri.parse(requestWarrantyUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'Email': email,
          'WarrantyCode': warrantyCode,
          'Reason': reason,
        }),
      );
      
      print('RequestWarranty URL: $requestWarrantyUrl');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      
      final data = jsonDecode(response.body);
      
      if (response.statusCode == 200 && data['success'] == true) {
        return {
          'success': true,
          'message': data['message'] ?? 'Warranty request submitted successfully'
        };
      } else {
        // 🔹 TRUYỀN CHI TIẾT MESSAGE TỪ SERVER
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to submit warranty request',
          'statusCode': response.statusCode
        };
      }
    } catch (e) {
      print('❌ Request warranty error: $e');
      return {
        'success': false,
        'message': 'Network error: $e'
      };
    }
  }

  // 🔹 HỦY WARRANTY REQUEST
  static Future<Map<String, dynamic>> cancelWarranty({
    required String email,
    required int warrantyId,
  }) async {
    try {
      print('🔄 Canceling warranty for: $email, id: $warrantyId');
      
      final response = await http.post(
        Uri.parse(cancelWarrantyUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'Email': email,
          'WarrantyId': warrantyId, 
        }),
      );
      
      print('CancelWarranty URL: $cancelWarrantyUrl');
      print('Request body: ${jsonEncode({'Email': email, 'WarrantyId': warrantyId})}');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      
      final data = jsonDecode(response.body);
      
      if (response.statusCode == 200 && data['success'] == true) {
        return {
          'success': true,
          'message': data['message'] ?? 'Warranty request canceled successfully'
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to cancel warranty request'
        };
      }
    } catch (e) {
      print('❌ Cancel warranty error: $e');
      return {
        'success': false,
        'message': 'Network error: $e'
      };
    }
  }
}