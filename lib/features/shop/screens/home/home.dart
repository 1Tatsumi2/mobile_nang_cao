// ignore_for_file: deprecated_member_use

import 'package:do_an_mobile/utils/constants/colors.dart';
import 'package:do_an_mobile/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// Header
            Container(
              color: TColors.black,
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              child: Column(
                children: [
                  /// AppBar
                  const SizedBox(height: TSizes.spaceBtwItems),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Good day for Shopping',
                            style: Theme.of(context).textTheme.labelMedium!
                                .apply(color: TColors.white),
                          ),
                          Text(
                            'MERDI Store',
                            style: Theme.of(context).textTheme.headlineSmall!
                                .apply(color: TColors.white),
                          ),
                        ],
                      ),

                      /// Cart Counter Icon
                      Stack(
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Iconsax.shopping_bag,
                              color: TColors.white,
                            ),
                          ),
                          Positioned(
                            right: 0,
                            child: Container(
                              width: 18,
                              height: 18,
                              decoration: BoxDecoration(
                                color: TColors.black,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Center(
                                child: Text(
                                  '2',
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
                      ),
                    ],
                  ),

                  /// SearchBar
                  const SizedBox(height: TSizes.spaceBtwItems),
                  TextFormField(
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Iconsax.search_normal),
                      hintText: 'Search in Store',
                      filled: true,
                      fillColor: TColors.white,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(
                          Radius.circular(TSizes.cardRadiusLg),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(
                          Radius.circular(TSizes.cardRadiusLg),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /// Full Screen Image with Text Overlay
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height:
                      MediaQuery.of(context).size.height -
                      (MediaQuery.of(context).padding.top + 180),
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/banner/home_banner.png'),
                      fit: BoxFit.cover,
                      alignment: Alignment(-0.4, 0.0),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height:
                      MediaQuery.of(context).size.height -
                      (MediaQuery.of(context).padding.top + 180),
                  color: Colors.black.withOpacity(0.2),
                ),
                Positioned.fill(
                  child: Stack(
                    children: [
                      Align(
                        alignment: const Alignment(0, -0.6),
                        child: const Text(
                          'MERDI',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 90,
                            letterSpacing: 20,
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ),
                      Align(
                        alignment: const Alignment(0, 0.4),
                        child: const Text(
                          'Merdi Lido',
                          style: TextStyle(color: Colors.white, fontSize: 30),
                        ),
                      ),
                      Align(
                        alignment: const Alignment(
                          0,
                          0.7,
                        ), // 👈 thấp hơn dòng chữ
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildWhiteBox('FOR HER'),
                            const SizedBox(width: 16),
                            _buildWhiteBox('FOR HIM'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            /// Body
            Padding(
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              child: Column(
                children: [
                  /// Categories
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Popular Categories',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text('View All'),
                      ),
                    ],
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),

                  /// Categories List
                  SizedBox(
                    height: 80,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: 6,
                      itemBuilder: (_, index) {
                        return Container(
                          width: 80,
                          margin: const EdgeInsets.only(
                            right: TSizes.spaceBtwItems,
                          ),
                          padding: const EdgeInsets.all(TSizes.sm),
                          decoration: BoxDecoration(
                            color: TColors.light,
                            borderRadius: BorderRadius.circular(
                              TSizes.cardRadiusMd,
                            ),
                          ),
                          child: const Center(child: Icon(Iconsax.category)),
                        );
                      },
                    ),
                  ),

                  /// Featured Products
                  const SizedBox(height: TSizes.spaceBtwSections),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Featured Products',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text('View All'),
                      ),
                    ],
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),

                  /// Featured Products Grid
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: TSizes.gridViewSpacing,
                          crossAxisSpacing: TSizes.gridViewSpacing,
                          mainAxisExtent: 288,
                        ),
                    itemCount: 4,
                    itemBuilder: (_, index) {
                      return Container(
                        decoration: BoxDecoration(
                          color: TColors.light,
                          borderRadius: BorderRadius.circular(
                            TSizes.cardRadiusMd,
                          ),
                        ),
                        child: Column(
                          children: [
                            /// Thumbnail
                            Container(
                              width: double.infinity,
                              height: 180,
                              decoration: const BoxDecoration(
                                color: TColors.light,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(TSizes.cardRadiusMd),
                                  topRight: Radius.circular(
                                    TSizes.cardRadiusMd,
                                  ),
                                ),
                              ),
                              child: const Center(child: Icon(Iconsax.image)),
                            ),

                            /// Details
                            Padding(
                              padding: const EdgeInsets.all(TSizes.sm),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Product Name',
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(
                                    height: TSizes.spaceBtwItems / 2,
                                  ),
                                  Text(
                                    '\$199.99',
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
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

Widget _buildWhiteBox(String text) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(TSizes.borderRadiusSm),
    ),
    child: Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    ),
  );
}
