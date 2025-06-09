// ignore_for_file: deprecated_member_use

import 'package:do_an_mobile/features/shop/screens/home/widgets/banner.dart';
import 'package:do_an_mobile/features/shop/screens/home/widgets/categories_home.dart';
import 'package:do_an_mobile/features/shop/screens/home/widgets/header_home.dart';
import 'package:do_an_mobile/features/shop/screens/home/widgets/top_products_carousel.dart';
import 'package:do_an_mobile/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final int _initialPage = 5000;
  late final PageController _pageController;
  int _currentPage = 5000;

  final List<String> productImages = [
    'assets/images/top_products/top_product_1.png',
    'assets/images/top_products/top_product_2.png',
    'assets/images/top_products/top_product_3.png',
    'assets/images/top_products/top_product_4.png',
    'assets/images/top_products/top_product_5.png',
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: _initialPage,
      viewportFraction: 0.5,
    );
    _currentPage = _initialPage;
  }

  void _goToPage(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    setState(() {
      _currentPage = index;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: HeaderDelegate(
              minExtent: 80, // Chiều cao khi thu nhỏ
              maxExtent: 180, // Chiều cao khi đầy đủ
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                TBanner(),

                /// Body
                Padding(
                  padding: const EdgeInsets.all(TSizes.defaultSpace),
                  child: Column(
                    children: [
                      /// Categories Title
                      const SizedBox(height: TSizes.spaceBtwSections),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'CURATED BY THE HOUSE',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: TSizes.spaceBtwSections),

                      /// Categories Body
                      TCategories(),

                      /// Top Products Title
                      Center(
                        child: Text(
                          'TOP PRODUCTS',
                          style: Theme.of(context).textTheme.headlineMedium,
                          textAlign: TextAlign.center,
                        ),
                      ),

                      /// Top Products Carousel
                      const SizedBox(height: TSizes.spaceBtwItems),
                      TopProductsCarousel(
                        pageController: _pageController,
                        currentPage: _currentPage,
                        productImages: productImages,
                        goToPage: _goToPage,
                      ),
                      const SizedBox(height: TSizes.spaceBtwSections * 5),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
