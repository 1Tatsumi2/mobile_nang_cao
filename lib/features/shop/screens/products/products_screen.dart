// ignore_for_file: deprecated_member_use

import 'package:do_an_mobile/features/shop/screens/products/female/handbags/widgets/handbags_banner.dart';
import 'package:do_an_mobile/features/shop/screens/products/female/shoes/widgets/female_shoes_banner.dart';
import 'package:do_an_mobile/features/shop/screens/products/female/widgets/female_banner.dart';
import 'package:do_an_mobile/features/shop/screens/products/male/bags/widgets/bags_banner.dart';
import 'package:do_an_mobile/features/shop/screens/products/male/shoes/widgets/male_shoes_banner.dart';
import 'package:do_an_mobile/features/shop/screens/products/male/widgets/male_banner.dart';
import 'package:do_an_mobile/features/shop/screens/products/widgets/list_products.dart';
import 'package:do_an_mobile/utils/constants/api_constants.dart';
import 'package:flutter/material.dart';

class ProductsScreen extends StatefulWidget {
  final String gender;
  final List<Map<String, dynamic>> products;
  final String? category; // thêm category

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
  bool showSortDropdown = false; // Thêm biến này
  bool showFilterDropdown = false;

  String selectedGender = '';
  String selectedCategory = '';
  String selectedSort = ''; // Thêm biến này

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

  @override
  Widget build(BuildContext context) {
    final imageBaseUrl = ApiConstants.productMediaUrl; // <-- dùng biến chung
    final double categoryBarHeight = 56;
    final double bannerHeight = 245;

    final colorList = colorFilters.keys.toList();
    final int colorColumnCount = 2;
    final int colorRowCount = (colorList.length / colorColumnCount).ceil();
    // Banner logic
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

    // Category bar widget
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
        // Category button with dropdown
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
        // Sort by button with dropdown
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
                child: TListProducts(
                  products: widget.products,
                  imageBaseUrl: imageBaseUrl,
                ),
              ),
            ],
          ),
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
                              borderRadius: BorderRadius.zero, // Không bo góc
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
                              borderRadius: BorderRadius.zero, // Không bo góc
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
          // Dropdown Category
          if (showCategoryDropdown)
            Positioned(
              left: MediaQuery.of(context).size.width / 4 * 1,
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
                              selectedCategory = 'All';
                              showCategoryDropdown = false;
                            });
                          },
                          style: TextButton.styleFrom(
                            backgroundColor:
                                selectedCategory == 'All'
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
                                'All',
                                style: TextStyle(
                                  color:
                                      selectedCategory == 'All'
                                          ? Colors.white
                                          : Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                              if (selectedCategory == 'All') ...[
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
                              selectedCategory = "Men's Bags";
                              showCategoryDropdown = false;
                            });
                          },
                          style: TextButton.styleFrom(
                            backgroundColor:
                                selectedCategory == "Men's Bags"
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
                                "Men's Bags",
                                style: TextStyle(
                                  color:
                                      selectedCategory == "Men's Bags"
                                          ? Colors.white
                                          : Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                              if (selectedCategory == "Men's Bags") ...[
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
                              selectedCategory = "Shoes";
                              showCategoryDropdown = false;
                            });
                          },
                          style: TextButton.styleFrom(
                            backgroundColor:
                                selectedCategory == "Shoes"
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
                                "Shoes",
                                style: TextStyle(
                                  color:
                                      selectedCategory == "Shoes"
                                          ? Colors.white
                                          : Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                              if (selectedCategory == "Shoes") ...[
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
          // Dropdown Filter
          if (showFilterDropdown)
            Positioned(
              left: 0,
              right: 0,
              top:
                  bannerHeight +
                  categoryBarHeight, // Bắt đầu ngay dưới thanh filter
              bottom: 0, // Kéo dài tới cuối màn hình
              child: Material(
                color: Colors.white,
                elevation: 8,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // COLOR column
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

                                // Tạo danh sách màu chia thành 2 cột
                                Table(
                                  columnWidths: const {
                                    0: FlexColumnWidth(1),
                                    1: FlexColumnWidth(1),
                                  },
                                  children: List.generate(colorRowCount, (row) {
                                    return TableRow(
                                      children: List.generate(colorColumnCount, (
                                        col,
                                      ) {
                                        int index = row + col * colorRowCount;
                                        if (index >= colorList.length) {
                                          return const SizedBox(); // Ô trống nếu thiếu
                                        }
                                        String color = colorList[index];
                                        return Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Checkbox(
                                              value: colorFilters[color],
                                              onChanged: (val) {
                                                setState(() {
                                                  colorFilters[color] = val!;
                                                });
                                              },
                                              fillColor:
                                                  MaterialStateProperty.resolveWith<
                                                    Color?
                                                  >((states) {
                                                    if (states.contains(
                                                      MaterialState.selected,
                                                    )) {
                                                      return Colors
                                                          .black; // Khi được chọn
                                                    }
                                                    return null; // Khi chưa chọn, dùng màu mặc định
                                                  }),
                                              checkColor: Colors.white,
                                            ),
                                            Flexible(
                                              child: Text(
                                                color,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                                softWrap: true,
                                              ),
                                            ),
                                          ],
                                        );
                                      }),
                                    );
                                  }),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 48),
                          // MATERIAL column
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
                                Wrap(
                                  spacing: 24,
                                  runSpacing: 12,
                                  children:
                                      materialFilters.keys.map((material) {
                                        return Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Checkbox(
                                              value: materialFilters[material],
                                              onChanged: (val) {
                                                setState(() {
                                                  materialFilters[material] =
                                                      val!;
                                                });
                                              },
                                              fillColor:
                                                  MaterialStateProperty.resolveWith<
                                                    Color?
                                                  >((states) {
                                                    if (states.contains(
                                                      MaterialState.selected,
                                                    )) {
                                                      return Colors.black;
                                                    }
                                                    return null;
                                                  }),
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
                                ),
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
                            onPressed: () {
                              setState(() {
                                showFilterDropdown = false;
                              });
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
                              setState(() {
                                colorFilters.updateAll((key, value) => false);
                                materialFilters.updateAll(
                                  (key, value) => false,
                                );
                              });
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
                  ),
                ),
              ),
            ),
          // Dropdown Sort by
          if (showSortDropdown)
            Positioned(
              left:
                  MediaQuery.of(context).size.width /
                  4 *
                  3, // Sort by là button thứ 4
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
                              selectedSort = 'Best Selling';
                              showSortDropdown = false;
                            });
                          },
                          style: TextButton.styleFrom(
                            backgroundColor:
                                selectedSort == 'Best Selling'
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
                                'Best Selling',
                                style: TextStyle(
                                  color:
                                      selectedSort == 'Best Selling'
                                          ? Colors.white
                                          : Colors.black,
                                  fontSize: 14,
                                ),
                              ),
                              if (selectedSort == 'Best Selling') ...[
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
                              selectedSort = 'Price: High to Low';
                              showSortDropdown = false;
                            });
                          },
                          style: TextButton.styleFrom(
                            backgroundColor:
                                selectedSort == 'Price: High to Low'
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
                                'Price: High to Low',
                                style: TextStyle(
                                  color:
                                      selectedSort == 'Price: High to Low'
                                          ? Colors.white
                                          : Colors.black,
                                  fontSize: 12,
                                ),
                              ),
                              if (selectedSort == 'Price: High to Low') ...[
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
                              selectedSort = 'Price: Low to High';
                              showSortDropdown = false;
                            });
                          },
                          style: TextButton.styleFrom(
                            backgroundColor:
                                selectedSort == 'Price: Low to High'
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
                                'Price: Low to High',
                                style: TextStyle(
                                  color:
                                      selectedSort == 'Price: Low to High'
                                          ? Colors.white
                                          : Colors.black,
                                  fontSize: 12,
                                ),
                              ),
                              if (selectedSort == 'Price: Low to High') ...[
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
        ],
      ),
    );
  }
}
