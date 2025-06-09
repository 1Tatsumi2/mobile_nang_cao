// ignore_for_file: deprecated_member_use

import 'package:do_an_mobile/common/widgets/filter_list/category_bar.dart';
import 'package:do_an_mobile/features/shop/screens/products/male/bags/widgets/bags_banner.dart';
import 'package:do_an_mobile/features/shop/screens/products/male/bags/widgets/bags_list.dart';
import 'package:flutter/material.dart';

class MaleBagsScreen extends StatelessWidget {
  const MaleBagsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data
    final products = [
      {
        'image': 'assets/images/top_products/top_product_1.png',
        'name': 'Elegant Heels',
        'price': '1,950',
      },
      {
        'image': 'assets/images/top_products/top_product_2.png',
        'name': 'Classic Bag',
        'price': '1,980',
      },
      {
        'image': 'assets/images/top_products/top_product_3.png',
        'name': 'Summer Sandals',
        'price': '2,450',
      },
      {
        'image': 'assets/images/top_products/top_product_4.png',
        'name': 'Mini Handbag',
        'price': '1,950',
      },
    ];

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          // 1. Hình ảnh banner
          TMaleBagsBanner(),
          // 2. Thanh ngang category, filter, sort by
          TCategoryBar(
            buttons: [
              CategoryButton(label: 'Gender'),
              CategoryButton(label: 'Category'),
              CategoryButton(label: 'Filter'),
              CategoryButton(label: 'Sort by'),
            ],
          ),
          // 3. Grid sản phẩm
          TMaleBagsListProducts(products: products),
        ],
      ),
    );
  }
}
