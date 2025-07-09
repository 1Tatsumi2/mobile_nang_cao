import 'package:do_an_mobile/navigation_menu.dart';
import 'package:do_an_mobile/features/shop/screens/products/widgets/list_products.dart';
import 'package:do_an_mobile/utils/constants/api_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:do_an_mobile/features/shop/controllers/wishlist_controller.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  bool showGenderDropdown = false;
  bool showCategoryDropdown = false;
  bool showSortDropdown = false;
  bool showFilterDropdown = false;

  String selectedGender = '';
  String selectedCategory = '';
  String selectedSort = '';

  Map<String, bool> colorFilters = {
    'Brown': false,
    'Black': false,
    'Bright Green': false,
    'Red': false,
    'White': false,
    'White&Black': false,
    'Orange': false,
  };
  Map<String, bool> materialFilters = {
    'Leather': false,
    'Canvas': false,
    'GC selected': false,
  };

  // Danh sách sản phẩm yêu thích mẫu
  // ...existing code...

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final wishlistController = Get.put(WishlistController());
    final imageBaseUrl = ApiConstants.productMediaUrl;
    final double categoryBarHeight = 56;
    final double bannerHeight = 245;

    final colorList = colorFilters.keys.toList();
    final int colorColumnCount = 2;
    final int colorRowCount = (colorList.length / colorColumnCount).ceil();

    // Banner cho Wishlist
    Widget banner = Container(
      height: bannerHeight,
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
            'https://media.gucci.com/content/HeroRegularStandard_1600x675/1738583137/HeroRegularStandard_Gucci-TierII-SS25-Jan25-SS25TIERII-STILLLIFE-S-28-1449_001_Default.jpg',
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        // Thêm overlay để text vẫn rõ ràng trên hình ảnh
        decoration: BoxDecoration(color: Colors.black.withOpacity(0.4)),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'MY WISHLIST',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Your favorite items collection',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
    // Category bar widget giống ProductsScreen
    Widget categoryBarWidget = Row(
      children: [
        // Gender button with dropdown
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                showGenderDropdown = !showGenderDropdown;
                showCategoryDropdown = false;
                showSortDropdown = false;
                showFilterDropdown = false;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                color:
                    selectedGender.isNotEmpty
                        ? Colors.black
                        : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Gender',
                    style: TextStyle(
                      color:
                          selectedGender.isNotEmpty
                              ? Colors.white
                              : Colors.black,
                      fontWeight:
                          selectedGender.isNotEmpty
                              ? FontWeight.bold
                              : FontWeight.normal,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    showGenderDropdown
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    size: 18,
                    color:
                        selectedGender.isNotEmpty ? Colors.white : Colors.black,
                  ),
                  if (selectedGender.isNotEmpty) ...[
                    const SizedBox(width: 8),
                    const Icon(Icons.check, color: Colors.white, size: 18),
                  ],
                ],
              ),
            ),
          ),
        ),
        // Category button
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                showCategoryDropdown = !showCategoryDropdown;
                showGenderDropdown = false;
                showSortDropdown = false;
                showFilterDropdown = false;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                color:
                    selectedCategory.isNotEmpty
                        ? Colors.black
                        : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Category',
                    style: TextStyle(
                      color:
                          selectedCategory.isNotEmpty
                              ? Colors.white
                              : Colors.black,
                      fontWeight:
                          selectedCategory.isNotEmpty
                              ? FontWeight.bold
                              : FontWeight.normal,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    showCategoryDropdown
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    size: 18,
                    color:
                        selectedCategory.isNotEmpty
                            ? Colors.white
                            : Colors.black,
                  ),
                  if (selectedCategory.isNotEmpty) ...[
                    const SizedBox(width: 8),
                    const Icon(Icons.check, color: Colors.white, size: 18),
                  ],
                ],
              ),
            ),
          ),
        ),
        // Filter button
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                showFilterDropdown = !showFilterDropdown;
                showGenderDropdown = false;
                showCategoryDropdown = false;
                showSortDropdown = false;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                color:
                    (colorFilters.containsValue(true) ||
                            materialFilters.containsValue(true))
                        ? Colors.black
                        : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Filter',
                    style: TextStyle(
                      color:
                          (colorFilters.containsValue(true) ||
                                  materialFilters.containsValue(true))
                              ? Colors.white
                              : Colors.black,
                      fontWeight:
                          (colorFilters.containsValue(true) ||
                                  materialFilters.containsValue(true))
                              ? FontWeight.bold
                              : FontWeight.normal,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    showFilterDropdown
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    size: 18,
                    color:
                        (colorFilters.containsValue(true) ||
                                materialFilters.containsValue(true))
                            ? Colors.white
                            : Colors.black,
                  ),
                  if (colorFilters.containsValue(true) ||
                      materialFilters.containsValue(true)) ...[
                    const SizedBox(width: 8),
                    const Icon(Icons.check, color: Colors.white, size: 18),
                  ],
                ],
              ),
            ),
          ),
        ),
        // Sort by button
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                showSortDropdown = !showSortDropdown;
                showGenderDropdown = false;
                showCategoryDropdown = false;
                showFilterDropdown = false;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                color:
                    selectedSort.isNotEmpty ? Colors.black : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Sort by',
                    style: TextStyle(
                      color:
                          selectedSort.isNotEmpty ? Colors.white : Colors.black,
                      fontWeight:
                          selectedSort.isNotEmpty
                              ? FontWeight.bold
                              : FontWeight.normal,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    showSortDropdown
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    size: 18,
                    color:
                        selectedSort.isNotEmpty ? Colors.white : Colors.black,
                  ),
                  if (selectedSort.isNotEmpty) ...[
                    const SizedBox(width: 8),
                    const Icon(Icons.check, color: Colors.white, size: 18),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          // Nội dung chính
          Column(
            children: [
              banner,
              categoryBarWidget,
              Expanded(
                child: Obx(() {
                  if (wishlistController.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (wishlistController.wishlistItems.isEmpty) {
                    return _buildEmptyWishlist();
                  }

                  final products =
                      wishlistController.wishlistItems.map((item) {
                        // 🔹 XỬ LÝ PRIMARY IMAGE
                        String primaryImageUrl = '';
                        if (item['image'] != null &&
                            item['image'].toString().isNotEmpty) {
                          final imagePath = item['image'].toString();
                          primaryImageUrl =
                              imagePath.startsWith('http')
                                  ? imagePath
                                  : '${ApiConstants.productMediaUrl}$imagePath';
                        }

                        // 🔹 XỬ LÝ TẤT CẢ IMAGES
                        List<String> allImageUrls = [];
                        if (item['images'] != null) {
                          final imagesList = List<String>.from(item['images']);
                          for (String imagePath in imagesList) {
                            if (imagePath.isNotEmpty) {
                              String fullImageUrl =
                                  imagePath.startsWith('http')
                                      ? imagePath
                                      : '${ApiConstants.productMediaUrl}$imagePath';
                              allImageUrls.add(fullImageUrl);
                            }
                          }
                        }

                        // 🔹 NẾU KHÔNG CÓ IMAGES THÌ DÙNG PRIMARY IMAGE
                        if (allImageUrls.isEmpty &&
                            primaryImageUrl.isNotEmpty) {
                          allImageUrls.add(primaryImageUrl);
                        }

                        print('🖼️ Wishlist product images:');
                        print('   - Primary: $primaryImageUrl');
                        print('   - All images: $allImageUrls');

                        return {
                          'id': item['productId'],
                          'name': item['productName'],
                          'price': item['price'],
                          'image': primaryImageUrl,
                          'images': allImageUrls, // 🔹 TRUYỀN TẤT CẢ IMAGES
                          'description': item['description'] ?? '',
                          'variations':
                              item['variations'] ?? <Map<String, dynamic>>[],
                        };
                      }).toList();

                  print('📋 Wishlist products count: ${products.length}');

                  // 🔹 SỬA: DÙNG TListProductsGrid THAY VÌ TListProducts
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TListProductsGrid(
                      products: products,
                      imageBaseUrl: ApiConstants.productMediaUrl,
                    ),
                  );
                }),
              ),
            ],
          ),
          // Các dropdown giống ProductsScreen (copy từ ProductsScreen)
          // Dropdown Gender
          if (showGenderDropdown)
            Positioned(
              left: MediaQuery.of(context).size.width / 4 * 0,
              top: bannerHeight + categoryBarHeight,
              width: MediaQuery.of(context).size.width / 4,
              child: Material(
                elevation: 4,
                child: Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              selectedGender = 'Men';
                              showGenderDropdown = false;
                            });
                          },
                          style: TextButton.styleFrom(
                            backgroundColor:
                                selectedGender == 'Men'
                                    ? Colors.black
                                    : Colors.transparent,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Men',
                                style: TextStyle(
                                  color:
                                      selectedGender == 'Men'
                                          ? Colors.white
                                          : Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                              if (selectedGender == 'Men') ...[
                                const SizedBox(width: 8),
                                const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                      Divider(
                        color: Colors.grey.shade300,
                        thickness: 1,
                        height: 0,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              selectedGender = 'Women';
                              showGenderDropdown = false;
                            });
                          },
                          style: TextButton.styleFrom(
                            backgroundColor:
                                selectedGender == 'Women'
                                    ? Colors.black
                                    : Colors.transparent,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Women',
                                style: TextStyle(
                                  color:
                                      selectedGender == 'Women'
                                          ? Colors.white
                                          : Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                              if (selectedGender == 'Women') ...[
                                const SizedBox(width: 8),
                                const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          // Dropdown Category (copy các dropdown khác từ ProductsScreen...)
          // Dropdown Filter (copy toàn bộ filter dropdown từ ProductsScreen...)
          // Dropdown Sort by (copy toàn bộ sort dropdown từ ProductsScreen...)
        ],
      ),
    );
  }

  Widget _buildEmptyWishlist() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 100, color: Colors.grey.shade400),
          const SizedBox(height: 20),
          Text(
            'Your wishlist is empty',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Add products you love to your wishlist',
            style: TextStyle(fontSize: 16, color: Colors.grey.shade500),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              final navigationController = Get.find<NavigationController>();
              navigationController.selectedIndex.value = 0;
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
            child: const Text('Start Shopping'),
          ),
        ],
      ),
    );
  }
}
