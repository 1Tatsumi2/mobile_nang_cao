import 'package:do_an_mobile/data/services/wishlist_service.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart'; // 🔹 THÊM IMPORT
import 'dart:convert'; // 🔹 THÊM IMPORT

class WishlistController extends GetxController {
  static WishlistController get instance => Get.find();

  final RxList<Map<String, dynamic>> wishlistItems =
      <Map<String, dynamic>>[].obs;
  final RxBool isLoading = false.obs;
  final RxSet<int> favoriteProductIds = <int>{}.obs;

  @override
  void onInit() {
    super.onInit();
    print('🎯 WishlistController initialized');

    // 🔹 LOAD FROM LOCAL FIRST (fast)
    loadFromLocal();

    // 🔹 THEN FETCH FROM DATABASE (sync với server)
    fetchWishlist();
  }

  // 🔹 SIMPLE SAVE - CHỈ LƯU VÀO 1 KEY DUY NHẤT
  Future<void> saveToLocal() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final wishlistData = {
        'favoriteIds': favoriteProductIds.toList(),
        'items': wishlistItems,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'version': '1.0',
      };

      print('💾 About to save: ${favoriteProductIds.toList()}');
      print('💾 Items count: ${wishlistItems.length}');

      final success = await prefs.setString(
        'WISHLIST_DATA_V1',
        jsonEncode(wishlistData),
      );

      if (success) {
        print(
          '💾 ✅ SAVED: ${favoriteProductIds.length} favorites, ${wishlistItems.length} items',
        );

        // 🔹 VERIFY NGAY SAU KHI LƯU
        final verify = prefs.getString('WISHLIST_DATA_V1');
        print('💾 🔍 Verify data exists: ${verify != null}');
        print('💾 🔍 Verify data length: ${verify?.length ?? 0}');
      } else {
        print('💾 ❌ SAVE FAILED');
      }
    } catch (e) {
      print('💥 Save error: $e');
    }
  }

  // 🔹 SIMPLE LOAD - CHỈ LOAD TỪ 1 KEY DUY NHẤT
  Future<void> loadFromLocal() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      print('🔍 Checking for saved data...');
      final savedData = prefs.getString('WISHLIST_DATA_V1');

      if (savedData != null) {
        final data = jsonDecode(savedData);

        // 🔹 LOAD FAVORITES
        final savedFavorites = List<int>.from(data['favoriteIds'] ?? []);
        favoriteProductIds.clear();
        favoriteProductIds.addAll(savedFavorites);

        // 🔹 LOAD ITEMS
        final savedItems = List<Map<String, dynamic>>.from(data['items'] ?? []);
        wishlistItems.clear();
        wishlistItems.addAll(savedItems);

        // 🔹 INFO
        final timestamp = data['timestamp'];
        final savedTime =
            timestamp != null
                ? DateTime.fromMillisecondsSinceEpoch(timestamp)
                : null;

        print(
          '📱 ✅ LOADED: ${favoriteProductIds.length} favorites, ${wishlistItems.length} items',
        );
        print('📱 🕐 Saved at: $savedTime');
      } else {
        print('📱 💭 No saved data found');
      }
    } catch (e) {
      print('💥 Load error: $e');
    }
  }

  // 🔹 SIMPLIFIED TOGGLE - KHÔNG AUTO-SAVE
  Future<void> toggleWishlist(
    int productId, {
    String? productName,
    double? price,
    String? image,
    String? description,
    List<Map<String, dynamic>>? variations,
    List<String>? images,
  }) async {
    try {
      print('🔄 Toggle wishlist for productId: $productId');

      if (favoriteProductIds.contains(productId)) {
        // 🔹 REMOVE FROM DATABASE + LOCAL
        print('➖ Removing from database and local...');

        final success = await WishlistService.removeFromWishlist(productId);
        if (success) {
          favoriteProductIds.remove(productId);
          wishlistItems.removeWhere((item) => item['productId'] == productId);
          await saveToLocal(); // Save local backup

          print('✅ Removed from database and local');
          Get.snackbar('Removed', 'Product removed from wishlist');
        } else {
          print('❌ Failed to remove from database');
          Get.snackbar('Error', 'Failed to remove from wishlist');
        }
      } else {
        // 🔹 ADD TO DATABASE + LOCAL
        print('➕ Adding to database and local...');

        final success = await WishlistService.addToWishlist(productId);
        if (success) {
          final productData = {
            'id': DateTime.now().millisecondsSinceEpoch,
            'productId': productId,
            'productName': productName ?? 'Unknown Product',
            'price': price ?? 0.0,
            'image': image ?? '',
            'images': images ?? [],
            'description': description ?? '',
            'variations': variations ?? [],
            'addedAt': DateTime.now().toIso8601String(),
          };

          favoriteProductIds.add(productId);
          wishlistItems.add(productData);
          await saveToLocal(); // Save local backup

          print('✅ Added to database and local');
          Get.snackbar('Added', 'Product added to wishlist');
        } else {
          print('❌ Failed to add to database');
          Get.snackbar('Error', 'Failed to add to wishlist');
        }
      }

      print('📱 Current favorites: ${favoriteProductIds.toList()}');
      print('📱 Current items count: ${wishlistItems.length}');
    } catch (e) {
      print('💥 Toggle error: $e');
      Get.snackbar('Error', 'Something went wrong: $e');
    }
  }

  // Nếu có method fetchWishlist trong WishlistController, thêm:
  Future<void> fetchWishlist() async {
    try {
      isLoading(true);
      print('🔄 Fetching wishlist from database...');

      final items = await WishlistService.getWishlist();
      print('📋 Database returned ${items.length} items');

      if (items.isNotEmpty) {
        print('✅ Syncing with database data...');

        // Clear và sync với database
        favoriteProductIds.clear();
        wishlistItems.clear();

        // Add data từ database
        for (var item in items) {
          favoriteProductIds.add(item['productId'] as int);
        }
        wishlistItems.addAll(items);

        // Save local backup
        await saveToLocal();

        print('✅ Synced ${favoriteProductIds.length} items from database');
      } else {
        print('💭 Database empty - keeping local data');
      }
    } catch (e) {
      print('💥 Fetch from database error: $e');
      print('💭 Using local data as fallback');
    } finally {
      isLoading(false);
    }
  }

  bool isFavorite(int productId) {
    return favoriteProductIds.contains(productId);
  }

  int get itemCount => favoriteProductIds.length;
}
