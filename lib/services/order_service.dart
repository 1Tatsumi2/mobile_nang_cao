// Tạo file: lib/services/order_service.dart
import 'dart:convert';
import 'package:flutter/material.dart'; // 🔹 THÊM import này
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants/api_constants.dart';

class OrderService {
  static Future<List<Map<String, dynamic>>> getUserOrders() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userEmail = prefs.getString('user_email');
      
      if (userEmail == null) {
        print('❌ No user email found');
        return [];
      }

      print('🔄 Fetching orders for: $userEmail');
      
      final response = await http.get(
        Uri.parse('${ApiConstants.accountApi}/GetUserOrders?email=$userEmail'),
        headers: {'Content-Type': 'application/json'},
      );

      print('Orders response status: ${response.statusCode}');
      print('Orders response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          return List<Map<String, dynamic>>.from(data['orders']);
        }
      }
      return [];
    } catch (e) {
      print('❌ Error getting orders: $e');
      return [];
    }
  }

  static Future<Map<String, dynamic>?> getOrderDetails(String orderCode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userEmail = prefs.getString('user_email');
      
      if (userEmail == null) {
        print('❌ No user email found');
        return null;
      }

      print('🔄 Fetching order details for: $orderCode');
      
      final response = await http.get(
        Uri.parse('${ApiConstants.accountApi}/GetOrderDetails?orderCode=$orderCode&email=$userEmail'),
        headers: {'Content-Type': 'application/json'},
      );

      print('Order details response status: ${response.statusCode}');
      print('Order details response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          return data;
        }
      }
      return null;
    } catch (e) {
      print('❌ Error getting order details: $e');
      return null;
    }
  }

  static Future<bool> cancelOrder(String orderCode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userEmail = prefs.getString('user_email');
      
      if (userEmail == null) {
        print('❌ No user email found');
        return false;
      }

      print('🔄 Canceling order: $orderCode');
      
      final response = await http.post(
        Uri.parse('${ApiConstants.accountApi}/CancelOrder'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': userEmail,
          'orderCode': orderCode,
        }),
      );

      print('Cancel order response status: ${response.statusCode}');
      print('Cancel order response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['success'] == true;
      }
      return false;
    } catch (e) {
      print('❌ Error canceling order: $e');
      return false;
    }
  }

  static Future<bool> confirmDelivery(String orderCode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userEmail = prefs.getString('user_email');
      
      if (userEmail == null) {
        print('❌ No user email found');
        return false;
      }

      print('🔄 Confirming delivery for: $orderCode');
      
      final response = await http.post(
        Uri.parse('${ApiConstants.accountApi}/ConfirmDelivery'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': userEmail,
          'orderCode': orderCode,
        }),
      );

      print('Confirm delivery response status: ${response.statusCode}');
      print('Confirm delivery response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['success'] == true;
      }
      return false;
    } catch (e) {
      print('❌ Error confirming delivery: $e');
      return false;
    }
  }

  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'new order':
        return Colors.blue;
      case 'confirmed':
        return Colors.orange;
      case 'in transit':
        return Colors.purple;
      case 'delivered':
        return Colors.green;
      case 'completed':
        return Colors.teal;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  static IconData getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'new order':
        return Icons.shopping_cart;
      case 'confirmed':
        return Icons.check_circle_outline;
      case 'in transit':
        return Icons.local_shipping;
      case 'delivered':
        return Icons.home;
      case 'completed':
        return Icons.check_circle;
      case 'cancelled':
        return Icons.cancel;
      default:
        return Icons.help_outline;
    }
  }
}