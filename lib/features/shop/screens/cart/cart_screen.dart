import 'package:do_an_mobile/features/shop/screens/cart/models/cart_item.dart';
import 'package:flutter/material.dart';
import 'package:do_an_mobile/utils/constants/api_constants.dart';
import 'package:do_an_mobile/services/product_service.dart';
import 'package:do_an_mobile/services/cart_service.dart';
import 'package:do_an_mobile/features/shop/screens/cart/models/checkout_request.dart'; // 🔹 THÊM IMPORT

import 'widgets/cart_header.dart';
import 'widgets/shipping_information.dart';
import 'widgets/order_payment_section.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late Future<List<CartItem>> cartItemsFuture;
  late Future<List<dynamic>> productsFuture;
  double? _shippingPrice;
  bool _isShippingSubmitted = false;
  ShippingAddressData? _shippingAddress; // 🔹 SỬ DỤNG TỪ checkout_request.dart

  @override
  void initState() {
    super.initState();
    cartItemsFuture = CartService.getCart();
    productsFuture = ProductService.fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Shopping Cart',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // Header Banner
            const CartHeader(),

            // Main Content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),

                  // Product Selection Section
                  FutureBuilder<List<CartItem>>(
                    future: cartItemsFuture,
                    builder: (context, cartSnapshot) {
                      if (cartSnapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (cartSnapshot.hasError) {
                        return Center(child: Text('Error: ${cartSnapshot.error}'));
                      }
                      final cartItems = cartSnapshot.data ?? [];
                      if (cartItems.isEmpty) {
                        return const Center(child: Text('Your cart is empty.'));
                      }
                      // Lồng FutureBuilder cho products
                      return FutureBuilder<List<dynamic>>(
                        future: productsFuture,
                        builder: (context, productSnapshot) {
                          if (productSnapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          if (productSnapshot.hasError) {
                            return Center(child: Text('Error: ${productSnapshot.error}'));
                          }
                          final products = productSnapshot.data ?? [];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "YOUR SELECTIONS",
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              const SizedBox(height: 12),
                              ...cartItems.map((item) {
                                // Tìm product chứa variation này
                                final product = products.firstWhere(
                                  (p) => (p['variations'] as List).any((v) => v['id'] == item.variationId),
                                  orElse: () => null,
                                );
                                // Tìm variation theo variationId
                                final variation = product != null
                                    ? (product['variations'] as List).firstWhere(
                                        (v) => v['id'] == item.variationId,
                                        orElse: () => null,
                                      )
                                    : null;
                                final colorName = variation?['color']?['name'] ?? '';
                                final materialName = variation?['material']?['name'] ?? '';
                                final imageUrl = variation?['image'] ?? item.imageUrl;

                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Ảnh variation
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          '${ApiConstants.variationMediaUrl}$imageUrl',
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover,
                                          errorBuilder: (c, e, s) => const Icon(Icons.broken_image, size: 60),
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      // Thông tin sản phẩm
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(item.productName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                                            Text('Style# $materialName - $colorName', style: const TextStyle(color: Colors.grey)),
                                            Text('Variation: $colorName - $materialName', style: const TextStyle(color: Colors.grey)),
                                            const SizedBox(height: 8),
                                            Row(
                                              children: [
                                                const Text('AVAILABLE', style: TextStyle(fontSize: 13, color: Colors.green)),
                                                const SizedBox(width: 12),
                                                Container(width: 1, height: 16, color: Colors.black),
                                                const SizedBox(width: 12),
                                                // Nút Remove (có thể gọi API xóa ở đây)
                                                TextButton(
                                                  onPressed: () async {
                                                    await CartService.removeFromCart(item.productId, item.variationId);
                                                    setState(() {
                                                      cartItemsFuture = CartService.getCart(); // Gán lại để FutureBuilder reload
                                                    });
                                                  },
                                                  style: TextButton.styleFrom(
                                                    foregroundColor: Colors.red,
                                                    textStyle: const TextStyle(fontWeight: FontWeight.bold),
                                                  ),
                                                  child: const Text('Remove'),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      // Số lượng và giá
                                      Column(
                                        children: [
                                          // Dropdown chọn số lượng
                                          DropdownButton<int>(
                                            value: item.quantity,
                                            items: List.generate(
                                              (variation?['stock'] ?? 1) > 20 ? 20 : (variation?['stock'] ?? 1),
                                              (index) => DropdownMenuItem(
                                                value: index + 1,
                                                child: Text('${index + 1}'),
                                              ),
                                            ),
                                            onChanged: (newQty) async {
                                              if (newQty != null) {
                                                // Cập nhật số lượng trong CartService
                                                await CartService.updateQuantity(item.productId, item.variationId, newQty);
                                                setState(() {
                                                  cartItemsFuture = CartService.getCart();
                                                });
                                              }
                                            },
                                          ),
                                          const SizedBox(height: 8),
                                          Text('\$${(item.price * item.quantity).toStringAsFixed(0)}',
                                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              }),
                              const SizedBox(height: 24),

                              // Divider
                              const Divider(color: Colors.grey, thickness: 0.5),
                              const SizedBox(height: 24),

                              // Shipping Information Section
                              ShippingInformation(
                                onShippingPriceChanged: (price) {
                                  setState(() {
                                    _shippingPrice = price;
                                  });
                                },
                                onShippingSubmitted: (isSubmitted) {
                                  setState(() {
                                    _isShippingSubmitted = isSubmitted;
                                  });
                                },
                                onShippingAddressChanged: (address) { // 🔹 CALLBACK NHẬN ShippingAddressData
                                  setState(() {
                                    _shippingAddress = address;
                                  });
                                },
                              ),
                              const SizedBox(height: 24),

                              // Divider
                              const Divider(color: Colors.grey, thickness: 0.5),
                              const SizedBox(height: 24),

                              // Order Summary and Payment Section
                              OrderPaymentSection(
                                cartItems: cartItems,
                                shipping: _shippingPrice ?? 0.0,
                                isShippingSubmitted: _isShippingSubmitted,
                                shippingAddress: _shippingAddress, // 🔹 TRUYỀN ĐỊA CHỈ
                              ),
                              const SizedBox(height: 24),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
