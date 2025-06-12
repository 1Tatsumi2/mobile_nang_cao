import 'package:do_an_mobile/common/widgets/filter_list/category_bar.dart';
import 'package:do_an_mobile/features/shop/screens/products/female/handbags/widgets/handbags_banner.dart';
import 'package:do_an_mobile/features/shop/screens/products/female/shoes/widgets/female_shoes_banner.dart';
import 'package:do_an_mobile/features/shop/screens/products/female/widgets/female_banner.dart';
import 'package:do_an_mobile/features/shop/screens/products/male/bags/widgets/bags_banner.dart';
import 'package:do_an_mobile/features/shop/screens/products/male/shoes/widgets/male_shoes_banner.dart';
import 'package:do_an_mobile/features/shop/screens/products/male/widgets/male_banner.dart';
import 'package:do_an_mobile/features/shop/screens/products/widgets/list_products.dart';
import 'package:flutter/material.dart';

class ProductsScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final imageBaseUrl = 'http://localhost:5139/media/products/';

    // Banner logic
    Widget banner;
    if (gender == "Women's" && category == "HandBags") {
      banner = TFemaleHandbagsBanner();
    } else if (gender == "Women's" && category == "Shoes") {
      banner = TFemaleShoesBanner();
    } else if (gender == "Men's" && category == "Shoes") {
      banner = TMaleShoesBanner();
    } else if (gender == "Men's" && category == "Bags") {
      banner = TMaleBagsBanner();
    } else {
      banner = gender == "Men's" ? TMaleBanner() : TFemaleBanner();
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          banner,
          TCategoryBar(
            buttons: [
              CategoryButton(label: 'Gender'),
              CategoryButton(label: 'Category'),
              CategoryButton(label: 'Filter'),
              CategoryButton(label: 'Sort by'),
            ],
          ),
          Expanded(
            child: TListProducts(
              products: products,
              imageBaseUrl: imageBaseUrl,
            ),
          ),
        ],
      ),
    );
  }
}