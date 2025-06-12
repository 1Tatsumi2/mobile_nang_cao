// ignore_for_file: deprecated_member_use

import 'package:do_an_mobile/common/widgets/filter_list/category_bar.dart';
import 'package:do_an_mobile/features/shop/screens/products/male/widgets/male_banner.dart';
import 'package:do_an_mobile/features/shop/screens/products/male/widgets/male_list_products.dart';
import 'package:flutter/material.dart';

class MaleProductsScreen extends StatelessWidget {
  final List<dynamic> products;
  const MaleProductsScreen(this.products, {super.key});

  @override
  Widget build(BuildContext context) {
    final imageBaseUrl =
        'http://localhost:5139/media/products/'; // Đổi thành IP backend nếu cần

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
          TMaleBanner(),
          // 2. Thanh ngang category, filter, sort by
          TCategoryBar(
            buttons: [
              CategoryButton(label: 'Gender'),
              CategoryButton(label: 'Category'),
              CategoryButton(label: 'Filter'),
              CategoryButton(label: 'Sort by'),
            ],
          ),
          // Hiển thị danh sách sản phẩm
          Expanded(
            child: TMaleListProducts(
              products: products.cast<Map<String, dynamic>>(),
              imageBaseUrl: imageBaseUrl,
            ),
          ),
        ],
      ),
    );
  }
}
