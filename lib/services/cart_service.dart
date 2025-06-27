import 'dart:convert';
import 'package:do_an_mobile/features/shop/screens/cart/models/cart_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartService {
  static const String cartKey = 'cart_items';

  static Future<void> addToCart(CartItem item) async {
    final prefs = await SharedPreferences.getInstance();
    final cartJson = prefs.getString(cartKey);
    List<CartItem> cart = [];
    if (cartJson != null) {
      cart = (jsonDecode(cartJson) as List)
          .map((e) => CartItem.fromJson(e))
          .toList();
    }
    // Kiểm tra trùng sản phẩm/variation
    final index = cart.indexWhere((c) =>
        c.productId == item.productId && c.variationId == item.variationId);
    if (index >= 0) {
      cart[index] = CartItem(
        productId: cart[index].productId,
        variationId: cart[index].variationId,
        productName: cart[index].productName,
        imageUrl: cart[index].imageUrl,
        quantity: cart[index].quantity + item.quantity,
        price: cart[index].price,
      );
    } else {
      cart.add(item);
    }
    await prefs.setString(cartKey, jsonEncode(cart.map((e) => e.toJson()).toList()));
  }

  static Future<List<CartItem>> getCart() async {
    final prefs = await SharedPreferences.getInstance();
    final cartJson = prefs.getString(cartKey);
    if (cartJson == null) return [];
    return (jsonDecode(cartJson) as List)
        .map((e) => CartItem.fromJson(e))
        .toList();
  }

  static Future<void> removeFromCart(int productId, int? variationId) async {
    final prefs = await SharedPreferences.getInstance();
    final cart = await getCart();
    cart.removeWhere((c) => c.productId == productId && c.variationId == variationId);
    await prefs.setString(cartKey, jsonEncode(cart.map((e) => e.toJson()).toList()));
  }

  static Future<void> clearCart() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(cartKey);
  }

  static Future<void> updateQuantity(int productId, int? variationId, int newQuantity) async {
    final prefs = await SharedPreferences.getInstance();
    final cartJson = prefs.getString(cartKey);
    if (cartJson == null) return;
    List<CartItem> cart = (jsonDecode(cartJson) as List)
        .map((e) => CartItem.fromJson(e))
        .toList();
    final index = cart.indexWhere((c) =>
        c.productId == productId && c.variationId == variationId);
    if (index >= 0) {
      cart[index] = CartItem(
        productId: cart[index].productId,
        variationId: cart[index].variationId,
        productName: cart[index].productName,
        imageUrl: cart[index].imageUrl,
        quantity: newQuantity,
        price: cart[index].price,
      );
      await prefs.setString(cartKey, jsonEncode(cart.map((e) => e.toJson()).toList()));
    }
  }
}