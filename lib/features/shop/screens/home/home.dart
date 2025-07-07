// ignore_for_file: deprecated_member_use

import 'package:do_an_mobile/features/shop/screens/home/widgets/banner.dart';
import 'package:do_an_mobile/features/shop/screens/home/widgets/categories_home.dart';
import 'package:do_an_mobile/features/shop/screens/home/widgets/header_home.dart';
import 'package:do_an_mobile/features/shop/screens/home/widgets/top_products_carousel.dart';
import 'package:do_an_mobile/services/product_service.dart'; // 🔹 THÊM IMPORT
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

  // 🔹 THÊM STATE CHO TOP PRODUCTS
  List<Map<String, dynamic>> topProducts = [];
  bool isLoadingTopProducts = true;

  // 🔹 FALLBACK IMAGES (nếu API fail)
  final List<String> fallbackImages = [
    'assets/images/top_products/top_product_1-removebg.png',
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
    _loadTopProducts(); // 🔹 LOAD DỮ LIỆU
  }

  // 🔹 LOAD TOP PRODUCTS TỪ API
  Future<void> _loadTopProducts() async {
    try {
      setState(() {
        isLoadingTopProducts = true;
      });

      final products = await ProductService.getTopProducts();
      
      setState(() {
        topProducts = products;
        isLoadingTopProducts = false;
      });

      print('✅ Loaded ${products.length} top products for home screen');
    } catch (e) {
      print('❌ Error loading top products: $e');
      setState(() {
        isLoadingTopProducts = false;
        // 🔹 FALLBACK DATA - SỬ DỤNG HÌNH CHÍNH CỦA PRODUCT
        topProducts = [
          {
            'id': 1,
            'name': 'Medium GG backpack with Web',
            'price': 3400.0,
            'imageUrl': 'product1.jpg', // 🔹 HÌNH CHÍNH CỦA PRODUCT
            'totalQuantitySold': 150,
            'description': 'Premium quality backpack with GG pattern',
            'images': ['product1.jpg', 'product1_2.jpg'], // 🔹 TẤT CẢ HÌNH CỦA PRODUCT
            'variations': [
              {
                'id': 1,
                'size': '30',
                'imageUrl': 'variation1.jpg', // 🔹 HÌNH CỦA VARIATION
                'color': {'id': 1, 'name': 'Black'},
                'material': {'id': 1, 'name': 'Leather'},
              },
              {
                'id': 2, 
                'size': '35',
                'imageUrl': 'variation2.jpg', // 🔹 HÌNH CỦA VARIATION
                'color': {'id': 2, 'name': 'Brown'},
                'material': {'id': 1, 'name': 'Leather'},
              }
            ],
          },
          // ... thêm các products khác
        ];
      });
    }
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

                      /// 🔹 Top Products Carousel với dữ liệu API
                      const SizedBox(height: TSizes.spaceBtwItems),
                      
                      // 🔹 HIỂN THỊ LOADING HOẶC CAROUSEL
                      isLoadingTopProducts
                          ? Container(
                              height: 350,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 151, 195, 216),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              child: const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircularProgressIndicator(color: Colors.white),
                                    SizedBox(height: 16),
                                    Text(
                                      'Loading top products...',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : TopProductsCarousel(
                              pageController: _pageController,
                              currentPage: _currentPage,
                              topProducts: topProducts, // 🔹 TRUYỀN DỮ LIỆU API
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
