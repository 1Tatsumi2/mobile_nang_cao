import 'package:get/get.dart';
import 'package:do_an_mobile/services/cart_service.dart';
import 'package:do_an_mobile/features/shop/screens/cart/models/cart_item.dart';

class CartController extends GetxController {
  static CartController get instance => Get.find();

  // 🔹 CART STATE
  final RxList<CartItem> cartItems = <CartItem>[].obs;
  final RxBool isLoading = false.obs;

  // 🔹 GETTERS
  int get cartItemCount {
    int total = cartItems.fold(0, (total, item) => total + item.quantity);
    print('🔢 Cart item count: $total');
    return total;
  }

  double get cartTotal {
    double total = cartItems.fold(0.0, (total, item) => total + (item.price * item.quantity));
    print('💰 Cart total: \$${total.toStringAsFixed(2)}');
    return total;
  }

  bool get isCartEmpty => cartItems.isEmpty;

  @override
  void onInit() {
    super.onInit();
    print('🚀 CartController initialized');
    loadCartItems();
  }

  // 🔹 LOAD CART ITEMS
  Future<void> loadCartItems() async {
    try {
      isLoading.value = true;
      print('📂 Loading cart items...');
      
      final items = await CartService.getCart();
      cartItems.assignAll(items);
      
      print('✅ Loaded ${items.length} cart items');
      for (var item in items) {
        print('   - ${item.productName} x${item.quantity} = \$${(item.price * item.quantity).toStringAsFixed(2)}');
      }
    } catch (e) {
      print('❌ Error loading cart: $e');
      cartItems.clear(); // Clear nếu có lỗi
    } finally {
      isLoading.value = false;
    }
  }

  // 🔹 ADD TO CART - SỬA LẠI VỚI THÊM DEBUG
  Future<void> addToCart(CartItem item) async {
    try {
      print('🛒 CartController.addToCart called:');
      print('   - Product: ${item.productName}');
      print('   - ProductID: ${item.productId}');
      print('   - VariationID: ${item.variationId}');
      print('   - Quantity: ${item.quantity}');
      print('   - Price: \$${item.price}');

      // 🔹 GỌI SERVICE TRƯỚC
      await CartService.addToCart(item);
      print('✅ CartService.addToCart completed');

      // 🔹 RELOAD ĐỂ CẬP NHẬT UI
      await loadCartItems();
      print('✅ Cart reloaded, new count: ${cartItems.length}');
      
      // 🔹 HIỂN THỊ THÔNG BÁO
      Get.snackbar(
        'Success',
        '${item.productName} added to cart',
        duration: const Duration(seconds: 2),
        snackPosition: SnackPosition.BOTTOM,
      );
      
    } catch (e) {
      print('❌ Error in CartController.addToCart: $e');
      Get.snackbar(
        'Error', 
        'Failed to add item to cart: $e',
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
    }
  }

  // 🔹 REMOVE FROM CART
  Future<void> removeFromCart(int productId, int? variationId) async {
    try {
      print('🗑️ Removing from cart: Product $productId, Variation $variationId');
      
      await CartService.removeFromCart(productId, variationId);
      await loadCartItems();
      
      Get.snackbar(
        'Removed',
        'Item removed from cart',
        duration: const Duration(seconds: 2),
        snackPosition: SnackPosition.BOTTOM,
      );
      
    } catch (e) {
      print('❌ Error removing from cart: $e');
      Get.snackbar('Error', 'Failed to remove item from cart');
    }
  }

  // 🔹 UPDATE QUANTITY
  Future<void> updateQuantity(int productId, int? variationId, int newQuantity) async {
    try {
      print('📝 Updating quantity: Product $productId = $newQuantity');
      
      if (newQuantity <= 0) {
        await removeFromCart(productId, variationId);
        return;
      }

      await CartService.updateQuantity(productId, variationId, newQuantity);
      await loadCartItems();
      
    } catch (e) {
      print('❌ Error updating quantity: $e');
      Get.snackbar('Error', 'Failed to update quantity');
    }
  }

  // 🔹 CLEAR CART
  Future<void> clearCart() async {
    try {
      print('🧹 CartController.clearCart called');
      
      await CartService.clearCart();
      cartItems.clear();
      
      Get.snackbar(
        'Cart Cleared',
        'All items removed from cart',
        duration: const Duration(seconds: 2),
      );
      
      print('🧹 Cart cleared, new count: ${cartItems.length}');
    } catch (e) {
      print('❌ Error clearing cart: $e');
      Get.snackbar('Error', 'Failed to clear cart');
    }
  }

  // 🔹 CLEAR CART VÀ CẬP NHẬT UI NGAY LẬP TỨC
  Future<void> clearCartAndUpdate() async {
    try {
      print('🧹 CartController.clearCartAndUpdate called');
      
      // Clear local state ngay lập tức
      cartItems.clear();
      print('🧹 Local cart cleared, count: ${cartItems.length}');
      
      // Clear service storage
      await CartService.clearCart();
      print('🧹 CartService cleared');
      
      // Force update UI
      update();
      
      print('🧹 ✅ Cart cleared and UI updated');
      
    } catch (e) {
      print('❌ Error in clearCartAndUpdate: $e');
    }
  }

  // 🔹 GET ITEM BY ID
  CartItem? getCartItem(int productId, int? variationId) {
    try {
      return cartItems.firstWhere(
        (item) => item.productId == productId && item.variationId == variationId,
      );
    } catch (e) {
      return null;
    }
  }

  // 🔹 CHECK IF ITEM EXISTS IN CART
  bool isInCart(int productId, int? variationId) {
    return cartItems.any(
      (item) => item.productId == productId && item.variationId == variationId,
    );
  }

  // 🔹 THÊM METHOD DEBUG
  void debugCartState() {
    print('🐛 === CART DEBUG INFO ===');
    print('   - Items count: ${cartItems.length}');
    print('   - Total quantity: $cartItemCount');
    print('   - Total price: \$${cartTotal.toStringAsFixed(2)}');
    print('   - Is loading: ${isLoading.value}');
    print('   - Items:');
    for (int i = 0; i < cartItems.length; i++) {
      final item = cartItems[i];
      print('     [$i] ${item.productName} (ID: ${item.productId}, Var: ${item.variationId}) x${item.quantity} = \$${item.price}');
    }
    print('🐛 === END DEBUG ===');
  }
}