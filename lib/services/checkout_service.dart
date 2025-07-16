import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:do_an_mobile/utils/constants/api_constants.dart';
import 'package:do_an_mobile/features/shop/screens/cart/models/checkout_request.dart';
import 'package:url_launcher/url_launcher.dart';

class CheckoutService {
  static Future<Map<String, dynamic>> processCheckout(CheckoutRequest request) async {
    try {
      final url = Uri.parse('${ApiConstants.baseUrl}api/ApiCheckout/Checkout'); // Sửa URL
      
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(request.toJson()),
      );

      print('Checkout URL: $url');
      print('Request body: ${jsonEncode(request.toJson())}');
      print('Response status: ${response.statusCode}');
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
          'error': 'Server error: ${response.statusCode}',
        };
      }
    } catch (e) {
      print('Checkout error: $e');
      return {
        'success': false,
        'error': 'Network error: $e',
      };
    }
  }

  static Future<void> launchPaymentUrl(String url) async {
    try {
      final Uri uri = Uri.parse(url);
      
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication, // Mở trong browser
        );
        print('✅ Payment URL launched successfully');
      } else {
        throw Exception('Cannot launch URL: $url');
      }
    } catch (e) {
      print('❌ Error launching payment URL: $e');
      throw e;
    }
  }
}