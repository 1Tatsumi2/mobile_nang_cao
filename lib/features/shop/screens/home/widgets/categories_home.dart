import 'package:do_an_mobile/features/shop/screens/products/female/handbags/female_handbags_screen.dart';
import 'package:do_an_mobile/features/shop/screens/products/female/shoes/female_shoes_screen.dart';
import 'package:do_an_mobile/features/shop/screens/products/male/bags/male_bags_screen.dart';
import 'package:do_an_mobile/features/shop/screens/products/male/shoes/male_shoes_screen.dart';
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
          onTap: () {
            if (index == 0) {
              Get.to(() => const FemaleHandbagsScreen());
            } else if (index == 1) {
              Get.to(() => const FemaleShoesScreen());
            } else if (index == 2) {
              Get.to(() => const MaleShoesScreen());
            } else if (index == 3) {
              Get.to(() => const MaleBagsScreen());
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
