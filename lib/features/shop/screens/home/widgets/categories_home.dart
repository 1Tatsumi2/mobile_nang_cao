import 'package:do_an_mobile/features/shop/screens/products/products_screen.dart';
import 'package:do_an_mobile/services/product_service.dart';
import 'package:flutter/material.dart';
import 'package:do_an_mobile/utils/constants/sizes.dart';
import 'package:get/get.dart';

class TCategories extends StatelessWidget {
  const TCategories({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: TSizes.gridViewSpacing,
        crossAxisSpacing: TSizes.gridViewSpacing,
        mainAxisExtent: 288,
      ),
      itemCount: 4,
      itemBuilder: (_, index) {
        final imageNames = [
          'assets/images/category/category_1.png',
          'assets/images/category/category_2.png',
          'assets/images/category/category_3.png',
          'assets/images/category/category_4.png',
        ];
        final captions = [
          'Women\'s Handbags',
          'Women\'s Shoes',
          'Men\'s Shoes',
          'Men\'s Bags',
        ];
        return InkWell(
          borderRadius: BorderRadius.circular(TSizes.cardRadiusSm),
          onTap: () async {
            if (index == 0) {
              // Women's Handbags
              final products = await ProductService.searchProducts(
                category: "Women's",
                brand: "Handbags",
              );
              Get.to(() => ProductsScreen(
                gender: "Women's",
                products: products.cast<Map<String, dynamic>>(),
                category: "Handbags",
              ));
            } else if (index == 1) {
              // Women's Shoes
              final products = await ProductService.searchProducts(
                category: "Women's",
                brand: "Shoes",
              );
              Get.to(() => ProductsScreen(
                gender: "Women's",
                products: products.cast<Map<String, dynamic>>(),
                category: "Shoes",
              ));
            } else if (index == 2) {
              // Men's Shoes
              final products = await ProductService.searchProducts(
                category: "Men's",
                brand: "Shoes",
              );
              Get.to(() => ProductsScreen(
                gender: "Men's",
                products: products.cast<Map<String, dynamic>>(),
                category: "Shoes",
              ));
            } else if (index == 3) {
              // Men's Bags
              final products = await ProductService.searchProducts(
                category: "Men's",
                brand: "Bags",
              );
              Get.to(() => ProductsScreen(
                gender: "Men's",
                products: products.cast<Map<String, dynamic>>(),
                category: "Bags",
              ));
            }
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(TSizes.cardRadiusSm),
            ),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(TSizes.cardRadiusSm),
                  child: Image.asset(
                    imageNames[index],
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 250,
                  ),
                ),
                const SizedBox(height: TSizes.spaceBtwItems),
                Text(
                  captions[index],
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
