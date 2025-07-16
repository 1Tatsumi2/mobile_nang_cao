import 'package:do_an_mobile/features/shop/screens/cart/cart_screen.dart';
import 'package:do_an_mobile/features/shop/screens/products/products_screen.dart';
import 'package:do_an_mobile/services/product_service.dart';
import 'package:do_an_mobile/utils/constants/colors.dart';
import 'package:do_an_mobile/utils/constants/sizes.dart';
import 'package:do_an_mobile/controllers/cart_controller.dart'; // 🔹 THÊM IMPORT
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:get/get.dart'; // 🔹 THÊM IMPORT

class HeaderDelegate extends SliverPersistentHeaderDelegate {
  final double _minExtent;
  final double _maxExtent;

  HeaderDelegate({required double minExtent, required double maxExtent})
    : _minExtent = minExtent,
      _maxExtent = maxExtent;

  @override
  double get minExtent => _minExtent;

  @override
  double get maxExtent => _maxExtent;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final percent = (shrinkOffset / (maxExtent - minExtent)).clamp(0.0, 1.0);

    // Thêm controller cho search
    final TextEditingController searchController = TextEditingController();

    Future<void> onSearch(String value) async {
      if (value.trim().isEmpty) return;
      final products = await ProductService.searchProducts(searchTerm: value.trim());
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ProductsScreen(
            gender: "All",
            products: products.cast<Map<String, dynamic>>(),
          ),
        ),
      );
    }

    return Container(
      color: TColors.black,
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Stack(
        children: [
          // Các text sẽ mờ dần và dịch lên trên khi scroll
          Opacity(
            opacity: 1 - percent,
            child:
                (1 - percent) > 0.05
                    ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: TSizes.spaceBtwItems),
                        Text(
                          'Good day for Shopping',
                          style: Theme.of(
                            context,
                          ).textTheme.labelMedium!.apply(color: TColors.white),
                        ),
                        Text(
                          'MERDI Store',
                          style: Theme.of(context).textTheme.headlineSmall!
                              .apply(color: TColors.white),
                        ),
                        const SizedBox(height: TSizes.spaceBtwItems),
                      ],
                    )
                    : const SizedBox.shrink(),
          ),
          // SearchBar và icon cart luôn hiện, dịch chuyển vị trí khi scroll
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              children: [
                // SearchBar sẽ co lại và dịch sang trái khi scroll
                Expanded(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 0),
                    margin: EdgeInsets.only(
                      right: percent * 12, // dịch sang phải khi thu nhỏ
                    ),
                    child: SizedBox(
                      height: 44,
                      child: TextFormField(
                        controller: searchController,
                        onFieldSubmitted: onSearch,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Iconsax.search_normal),
                          hintText: 'Search in Store',
                          filled: true,
                          fillColor: TColors.white,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 8,
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.all(
                              Radius.circular(TSizes.cardRadiusXs),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.all(
                              Radius.circular(TSizes.cardRadiusXs),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // 🔹 CART ICON VỚI COUNTER THỰC TẾ
                GetX<CartController>(
                  init: CartController(), // 🔹 KHỞI TẠO CONTROLLER
                  builder: (cartController) {
                    return Stack(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CartScreen(),
                              ),
                            );
                          },
                          icon: const Icon(
                            Iconsax.shopping_bag,
                            color: TColors.white,
                          ),
                        ),
                        // 🔹 BADGE VỚI SỐ LƯỢNG THỰC TẾ
                        if (cartController.cartItemCount > 0)
                          Positioned(
                            right: 0,
                            child: Container(
                              width: 18,
                              height: 18,
                              decoration: BoxDecoration(
                                color: TColors.error, // 🔹 ĐỔI MÀU ĐỂ NỔI BẬT HƠN
                                borderRadius: BorderRadius.circular(100),
                                border: Border.all(color: TColors.white, width: 1),
                              ),
                              child: Center(
                                child: Text(
                                  '${cartController.cartItemCount > 99 ? "99+" : cartController.cartItemCount}', // 🔹 SỐ LƯỢNG THỰC TẾ
                                  style: Theme.of(
                                    context,
                                  ).textTheme.labelLarge!.apply(
                                    color: TColors.white,
                                    fontSizeFactor: 0.8,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(HeaderDelegate oldDelegate) => true;
}
