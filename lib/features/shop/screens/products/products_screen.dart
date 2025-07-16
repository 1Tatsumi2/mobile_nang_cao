// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:do_an_mobile/controllers/filter_controller.dart';
import 'package:do_an_mobile/services/filter_service.dart';
import 'package:do_an_mobile/features/shop/screens/products/female/handbags/widgets/handbags_banner.dart';
import 'package:do_an_mobile/features/shop/screens/products/female/shoes/widgets/female_shoes_banner.dart';
import 'package:do_an_mobile/features/shop/screens/products/female/widgets/female_banner.dart';
import 'package:do_an_mobile/features/shop/screens/products/male/bags/widgets/bags_banner.dart';
import 'package:do_an_mobile/features/shop/screens/products/male/shoes/widgets/male_shoes_banner.dart';
import 'package:do_an_mobile/features/shop/screens/products/male/widgets/male_banner.dart';
import 'package:do_an_mobile/features/shop/screens/products/widgets/list_products.dart';
import 'package:do_an_mobile/utils/constants/api_constants.dart';

class ProductsScreen extends StatefulWidget {
  final String gender;
  final List<Map<String, dynamic>> products;
  final String? category;

  const ProductsScreen({
    super.key,
    required this.gender,
    required this.products,
    this.category,
  });

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  bool showGenderDropdown = false;
  bool showCategoryDropdown = false;
  bool showSortDropdown = false;
  bool showFilterDropdown = false;

  // 🔹 THÊM FILTER CONTROLLER
  late FilterController filterController;
  late List<Map<String, dynamic>> displayProducts;

  @override
  void initState() {
    super.initState();
    // 🔹 KHỞI TẠO FILTER CONTROLLER
    filterController = Get.put(FilterController());
    displayProducts = widget.products;

    // 🔹 INIT FILTERS WITHOUT APPLYING (CHỈ SET GIÁ TRỊ, KHÔNG GỌI API)
    String? initGender;
    String? initCategory;

    if (widget.gender == "Men's") {
      initGender = 'Men';
    } else if (widget.gender == "Women's") {
      initGender = 'Women';
    }

    if (widget.category != null) {
      initCategory = widget.category!;
    }

    // 🔹 SỬ DỤNG INIT METHOD THAY VÌ SET TRỰC TIẾP
    filterController.initFilters(
      gender: initGender,
      category: initCategory,
    );

    // 🔹 DEBUG LOG
    print('🔍 ProductsScreen initialized:');
    print('  - Gender: ${widget.gender}');
    print('  - Category: ${widget.category}');
    print('  - Products count: ${widget.products.length}');
    print('  - Init gender: $initGender');
    print('  - Init category: $initCategory');
  }

  @override
  Widget build(BuildContext context) {
    final imageBaseUrl = ApiConstants.productMediaUrl;
    final double categoryBarHeight = 56;
    final double bannerHeight = 245;

    // Banner logic (giữ nguyên)
    Widget banner;
    if (widget.gender == "Women's" && widget.category == "HandBags") {
      banner = TFemaleHandbagsBanner();
    } else if (widget.gender == "Women's" && widget.category == "Shoes") {
      banner = TFemaleShoesBanner();
    } else if (widget.gender == "Men's" && widget.category == "Shoes") {
      banner = TMaleShoesBanner();
    } else if (widget.gender == "Men's" && widget.category == "Bags") {
      banner = TMaleBagsBanner();
    } else {
      banner = widget.gender == "Men's" ? TMaleBanner() : TFemaleBanner();
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Obx(() => Stack(
            children: [
              // Nội dung chính
              Column(
                children: [
                  banner,
                  _buildCategoryBar(),

                  // 🔹 HIỂN THỊ LOADING, EMPTY STATE HOẶC PRODUCTS
                  Expanded(
                    child: filterController.isLoading.value
                        ? const Center(child: CircularProgressIndicator())
                        : _buildProductsList(),
                  ),
                ],
              ),

              // 🔹 CÁC DROPDOWN (cập nhật với Obx)
              if (showGenderDropdown)
                _buildGenderDropdown(bannerHeight, categoryBarHeight),
              if (showCategoryDropdown)
                _buildCategoryDropdown(bannerHeight, categoryBarHeight),
              if (showSortDropdown) _buildSortDropdown(bannerHeight, categoryBarHeight),
              if (showFilterDropdown) _buildFilterDropdown(bannerHeight, categoryBarHeight),
            ],
          )),
    );
  }

  // 🔹 BUILD CATEGORY BAR
  Widget _buildCategoryBar() {
    return Obx(() => Row(
          children: [
            // Gender button
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
                    color: filterController.selectedGender.value.isNotEmpty
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
                          color: filterController.selectedGender.value.isNotEmpty
                              ? Colors.white
                              : Colors.black,
                          fontWeight: filterController.selectedGender.value.isNotEmpty
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
                        color: filterController.selectedGender.value.isNotEmpty
                            ? Colors.white
                            : Colors.black,
                      ),
                      if (filterController.selectedGender.value.isNotEmpty) ...[
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
                    color: filterController.selectedCategory.value.isNotEmpty
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
                          color: filterController.selectedCategory.value.isNotEmpty
                              ? Colors.white
                              : Colors.black,
                          fontWeight: filterController.selectedCategory.value.isNotEmpty
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
                        color: filterController.selectedCategory.value.isNotEmpty
                            ? Colors.white
                            : Colors.black,
                      ),
                      if (filterController.selectedCategory.value.isNotEmpty) ...[
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
                    color: (filterController.colorFilters.containsValue(true) ||
                            filterController.materialFilters.containsValue(true))
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
                          color: (filterController.colorFilters.containsValue(true) ||
                                  filterController.materialFilters.containsValue(true))
                              ? Colors.white
                              : Colors.black,
                          fontWeight: (filterController.colorFilters.containsValue(true) ||
                                  filterController.materialFilters.containsValue(true))
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
                        color: (filterController.colorFilters.containsValue(true) ||
                                filterController.materialFilters.containsValue(true))
                            ? Colors.white
                            : Colors.black,
                      ),
                      if (filterController.colorFilters.containsValue(true) ||
                          filterController.materialFilters.containsValue(true)) ...[
                        const SizedBox(width: 8),
                        const Icon(Icons.check, color: Colors.white, size: 18),
                      ],
                    ],
                  ),
                ),
              ),
            ),

            // Sort button
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
                    color: filterController.selectedSort.value.isNotEmpty
                        ? Colors.black
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Sort by',
                        style: TextStyle(
                          color: filterController.selectedSort.value.isNotEmpty
                              ? Colors.white
                              : Colors.black,
                          fontWeight: filterController.selectedSort.value.isNotEmpty
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
                        color: filterController.selectedSort.value.isNotEmpty
                            ? Colors.white
                            : Colors.black,
                      ),
                      if (filterController.selectedSort.value.isNotEmpty) ...[
                        const SizedBox(width: 8),
                        const Icon(Icons.check, color: Colors.white, size: 18),
                      ],
                    ],
                  ),
                ),
              ),
              ),
            ],
          ));
  }

  // 🔹 BUILD FILTER DROPDOWN
  Widget _buildFilterDropdown(double bannerHeight, double categoryBarHeight) {
    return Positioned(
      left: 0,
      right: 0,
      top: bannerHeight + categoryBarHeight,
      bottom: 0,
      child: Material(
        color: Colors.white,
        elevation: 8,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Obx(() => Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // COLOR section
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'COLOR',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ...filterController.colorFilters.keys.map((color) {
                              return Row(
                                children: [
                                  Checkbox(
                                    value: filterController.colorFilters[color],
                                    onChanged: (val) {
                                      filterController.toggleColorFilter(color);
                                    },
                                    fillColor:
                                        MaterialStateProperty.resolveWith<Color?>(
                                      (states) {
                                        if (states.contains(MaterialState.selected)) {
                                          return Colors.black;
                                        }
                                        return null;
                                      },
                                    ),
                                    checkColor: Colors.white,
                                  ),
                                  Flexible(
                                    child: Text(
                                      color,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                      const SizedBox(width: 48),
                      // MATERIAL section
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'MATERIAL',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ...filterController.materialFilters.keys.map((material) {
                              return Row(
                                children: [
                                  Checkbox(
                                    value: filterController.materialFilters[material],
                                    onChanged: (val) {
                                      filterController.toggleMaterialFilter(material);
                                    },
                                    fillColor:
                                        MaterialStateProperty.resolveWith<Color?>(
                                      (states) {
                                        if (states.contains(MaterialState.selected)) {
                                          return Colors.black;
                                        }
                                        return null;
                                      },
                                    ),
                                    checkColor: Colors.white,
                                  ),
                                  Text(
                                    material,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  const Divider(),
                  const SizedBox(height: 8),
                  const Text(
                    'You can select several options at once',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 12,
                          ),
                        ),
                        onPressed: () async {
                          setState(() {
                            showFilterDropdown = false;
                          });
                          await filterController.applyFilters();
                        },
                        child: const Text(
                          'Apply',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 12,
                          ),
                        ),
                        onPressed: () {
                          filterController.resetFilters();
                        },
                        child: const Text(
                          'Reset',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )),
        ),
      ),
    );
  }

  // 🔹 BUILD GENDER DROPDOWN
  Widget _buildGenderDropdown(double bannerHeight, double categoryBarHeight) {
    return Positioned(
      left: MediaQuery.of(context).size.width / 4 * 0,
      top: bannerHeight + categoryBarHeight,
      width: MediaQuery.of(context).size.width / 4,
      child: Material(
        elevation: 4,
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              _buildDropdownItem(
                'Men',
                filterController.selectedGender.value == 'Men',
                () async {
                  filterController.selectedGender.value = 'Men'; // Set trực tiếp
                  setState(() {
                    showGenderDropdown = false;
                  });
                  // 🔹 GỌI APPLY FILTERS SAU KHI SET
                  await filterController.applyFilters();
                },
              ),
              Divider(color: Colors.grey.shade300, thickness: 1, height: 0),
              _buildDropdownItem(
                'Women',
                filterController.selectedGender.value == 'Women',
                () async {
                  filterController.selectedGender.value = 'Women'; // Set trực tiếp
                  setState(() {
                    showGenderDropdown = false;
                  });
                  // 🔹 GỌI APPLY FILTERS SAU KHI SET
                  await filterController.applyFilters();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🔹 BUILD CATEGORY DROPDOWN
  Widget _buildCategoryDropdown(double bannerHeight, double categoryBarHeight) {
    return Positioned(
      left: MediaQuery.of(context).size.width / 4 * 1,
      top: bannerHeight + categoryBarHeight,
      width: MediaQuery.of(context).size.width / 4,
      child: Material(
        elevation: 4,
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              // ALL
              _buildDropdownItem(
                'All',
                filterController.selectedCategory.value == 'All' || filterController.selectedCategory.value.isEmpty,
                () async {
                  filterController.selectedCategory.value = 'All';
                  setState(() {
                    showCategoryDropdown = false;
                  });
                  await filterController.applyFilters();
                },
              ),
              Divider(color: Colors.grey.shade300, thickness: 1, height: 0),
              
              // HANDBAGS (Women only)
              if (filterController.selectedGender.value == 'Women' || filterController.selectedGender.value.isEmpty)
                _buildDropdownItem(
                  'Handbags',
                  filterController.selectedCategory.value == 'Handbags',
                  () async {
                    filterController.selectedCategory.value = 'Handbags';
                    setState(() {
                      showCategoryDropdown = false;
                    });
                    await filterController.applyFilters();
                  },
                ),
              if (filterController.selectedGender.value == 'Women' || filterController.selectedGender.value.isEmpty)
                Divider(color: Colors.grey.shade300, thickness: 1, height: 0),
            
              // MEN'S BAGS (Men only)
              if (filterController.selectedGender.value == 'Men' || filterController.selectedGender.value.isEmpty)
                _buildDropdownItem(
                  "Men's Bags",
                  filterController.selectedCategory.value == "Men's Bags",
                  () async {
                    filterController.selectedCategory.value = "Men's Bags";
                    setState(() {
                      showCategoryDropdown = false;
                    });
                    await filterController.applyFilters();
                  },
                ),
              if (filterController.selectedGender.value == 'Men' || filterController.selectedGender.value.isEmpty)
                Divider(color: Colors.grey.shade300, thickness: 1, height: 0),
            
              // SHOES (Both genders)
              _buildDropdownItem(
                'Shoes',
                filterController.selectedCategory.value == 'Shoes',
                () async {
                  filterController.selectedCategory.value = 'Shoes';
                  setState(() {
                    showCategoryDropdown = false;
                  });
                  await filterController.applyFilters();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🔹 BUILD SORT DROPDOWN
  Widget _buildSortDropdown(double bannerHeight, double categoryBarHeight) {
    return Positioned(
      left: MediaQuery.of(context).size.width / 4 * 3,
      top: bannerHeight + categoryBarHeight,
      width: MediaQuery.of(context).size.width / 4,
      child: Material(
        elevation: 4,
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              _buildDropdownItem(
                'Best Selling',
                filterController.selectedSort.value == 'Best Selling',
                () async {
                  filterController.selectedSort.value = 'Best Selling';
                  setState(() {
                    showSortDropdown = false;
                  });
                  await filterController.applyFilters();
                },
              ),
              Divider(color: Colors.grey.shade300, thickness: 1, height: 0),
              _buildDropdownItem(
                'Price: High to Low',
                filterController.selectedSort.value == 'Price: High to Low',
                () async {
                  filterController.selectedSort.value = 'Price: High to Low';
                  setState(() {
                    showSortDropdown = false;
                  });
                  await filterController.applyFilters();
                },
              ),
              Divider(color: Colors.grey.shade300, thickness: 1, height: 0),
              _buildDropdownItem(
                'Price: Low to High',
                filterController.selectedSort.value == 'Price: Low to High',
                () async {
                  filterController.selectedSort.value = 'Price: Low to High';
                  setState(() {
                    showSortDropdown = false;
                  });
                  await filterController.applyFilters();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🔹 HELPER METHOD FOR DROPDOWN ITEMS
  Widget _buildDropdownItem(String text, bool isSelected, VoidCallback onTap) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          backgroundColor: isSelected ? Colors.black : Colors.transparent,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontSize: 16,
              ),
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              const Icon(Icons.check, color: Colors.white, size: 18),
            ],
          ],
        ),
      ),
    );
  }

  // 🔹 THÊM METHOD MỚI ĐỂ XỬ LÝ HIỂN THỊ
  Widget _buildProductsList() {
    // 🔹 CHỈ HIỂN THỊ FILTERED RESULTS KHI USER ĐÃ MANUALLY APPLY FILTERS
    if (filterController.hasManuallyAppliedFilters && filterController.filteredProducts.isNotEmpty) {
      print('📋 Showing filtered products: ${filterController.filteredProducts.length}');
      return TListProducts(
        products: filterController.filteredProducts.value,
        imageBaseUrl: ApiConstants.productMediaUrl,
      );
    }
    
    // 🔹 NẾU ĐÃ APPLY FILTERS NHƯNG KHÔNG CÓ KẾT QUẢ
    if (filterController.hasManuallyAppliedFilters && filterController.filteredProducts.isEmpty) {
      print('📋 Showing empty state (manual filters applied, no results)');
      return _buildEmptyState();
    }
    
    // 🔹 HIỂN THỊ PRODUCTS BAN ĐẦU (TỪNG HOME HOẶC CATEGORY)
    print('📋 Showing initial products: ${displayProducts.length}');
    return TListProducts(
      products: displayProducts,
      imageBaseUrl: ApiConstants.productMediaUrl,
    );
  }

  // 🔹 THÊM EMPTY STATE WIDGET
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 80,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'No products found',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your filters or search criteria',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                filterController.resetFilters();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              child: const Text('Clear Filters'),
            ),
          ],
        ),
      ),
    );
  }
}
