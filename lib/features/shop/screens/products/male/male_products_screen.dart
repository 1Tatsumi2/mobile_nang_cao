// ignore_for_file: deprecated_member_use

import 'package:do_an_mobile/common/widgets/filter_list/category_bar.dart';
import 'package:do_an_mobile/features/shop/screens/products/male/widgets/male_banner.dart';
import 'package:do_an_mobile/features/shop/screens/products/male/widgets/male_list_products.dart';
import 'package:flutter/material.dart';
import 'package:do_an_mobile/services/product_service.dart'; // Thêm import này

class MaleProductsScreen extends StatefulWidget {
  const MaleProductsScreen({super.key});

  @override
  State<MaleProductsScreen> createState() => _MaleProductsScreenState();
}

class _MaleProductsScreenState extends State<MaleProductsScreen> {
  late Future<List<dynamic>> _futureProducts;

  @override
  void initState() {
    super.initState();
    _futureProducts = ProductService.fetchProducts(); // Gọi API
  }

  @override
  Widget build(BuildContext context) {
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
          // Sử dụng FutureBuilder để lấy dữ liệu từ API
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: _futureProducts,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No products found.'));
                }
                final products = snapshot.data!;
                final imageBaseUrl = 'http://localhost:5139/media/products/'; // Đổi thành IP backend của bạn

                return TMaleListProducts(
                  products: products.cast<Map<String, dynamic>>(),
                  imageBaseUrl: imageBaseUrl,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
