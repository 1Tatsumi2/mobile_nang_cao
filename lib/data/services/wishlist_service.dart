import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:do_an_mobile/utils/constants/api_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WishlistService {
  static Future<List<Map<String, dynamic>>> getWishlist() async {
    try {
      // 🔹 LẤY USERID TỪ SHAREPREFERENCES
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('user_id');

      if (userId == null || userId.isEmpty) {
        print('💭 No userId found - returning empty list');
        return [];
      }

      print('🔍 Fetching wishlist for userId: $userId');
      final url = '${ApiConstants.getWishlist}?userId=$userId';

      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      print('📡 GET Response Status: ${response.statusCode}');
      print('📡 GET Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final dynamic rawData = json.decode(response.body);

        if (rawData == null) {
          print('💭 Server returned null - preserving local state');
          return [];
        }

        final List<dynamic> data = rawData as List<dynamic>;

        final List<Map<String, dynamic>> wishlistItems = [];
        for (var item in data) {
          final Map<String, dynamic> wishlistItem = {
            'id': item['id'] ?? 0,
            'productId': item['productId'] ?? 0,
            'productName': item['productName'] ?? '',
            'price': (item['price'] ?? 0.0).toDouble(),
            'image': item['image'] ?? '',
            'images': item['images'] ?? [],
            'description': item['description'] ?? '',
            'addedAt': item['addedAt'] ?? DateTime.now().toIso8601String(),
          };
          wishlistItems.add(wishlistItem);
        }

        return wishlistItems;
      } else {
        throw Exception('Failed to load wishlist: ${response.statusCode}');
      }
    } catch (e) {
      print('💥 Wishlist fetch error: $e');
      return [];
    }
  }

  static Future<bool> addToWishlist(int productId) async {
    try {
      // 🔹 LẤY USERID TỪ SHAREPREFERENCES
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('user_id');

      if (userId == null || userId.isEmpty) {
        print('💭 No userId found - cannot add to server wishlist');
        return true; // Return true để vẫn add local
      }

      print('🔍 Adding productId $productId to wishlist for userId: $userId');

      final response = await http.post(
        Uri.parse(ApiConstants.addToWishlist),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'productId': productId, 'userId': userId}),
      );

      print('📡 POST Response Status: ${response.statusCode}');
      print('📡 POST Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData['success'] ?? true;
      }

      return false;
    } catch (e) {
      print('💥 Add wishlist error: $e');
      return true; // Return true để vẫn add local khi có lỗi
    }
  }

  static Future<bool> removeFromWishlist(int productId) async {
    try {
      // 🔹 LẤY USERID TỪ SHAREPREFERENCES
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('user_id');

      if (userId == null || userId.isEmpty) {
        print('💭 No userId found - cannot remove from server wishlist');
        return true; // Return true để vẫn remove local
      }

      print(
        '🔍 Removing productId $productId from wishlist for userId: $userId',
      );
      final url =
          '${ApiConstants.removeFromWishlist}?userId=$userId&productId=$productId';

      final response = await http.delete(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      print('📡 DELETE Response Status: ${response.statusCode}');
      print('📡 DELETE Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData['success'] ?? true;
      }

      return false;
    } catch (e) {
      print('💥 Remove wishlist error: $e');
      return true; // Return true để vẫn remove local khi có lỗi
    }
  }
}
