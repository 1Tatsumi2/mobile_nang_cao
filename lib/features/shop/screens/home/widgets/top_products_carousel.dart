// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:do_an_mobile/utils/constants/api_constants.dart';
import 'package:do_an_mobile/features/shop/screens/products/product_detail/product_detail_screen.dart';

class TopProductsCarousel extends StatelessWidget {
  final PageController pageController;
  final int currentPage;
  final List<Map<String, dynamic>> topProducts;
  final void Function(int) goToPage;

  const TopProductsCarousel({
    super.key,
    required this.pageController,
    required this.currentPage,
    required this.topProducts,
    required this.goToPage,
  });

  void _navigateToProductDetail(BuildContext context, Map<String, dynamic> product) {
    final productId = product['id'] as int? ?? 0;
    final productName = product['name'] as String? ?? 'Unknown Product';
    final price = product['price'] as double? ?? 0.0;
    final description = product['description'] as String? ?? '';
    
    print('🔍 Navigating to product: $productName (ID: $productId)');
    
    // 🔹 SỬ DỤNG HÌNH CHÍNH CỦA PRODUCT
    final productImageUrl = product['imageUrl'] as String? ?? '';
    final mainImageUrl = productImageUrl.isNotEmpty 
        ? '${ApiConstants.productMediaUrl}$productImageUrl'
        : '';

    print('🖼️ Main image URL: $mainImageUrl');

    // 🔹 DEBUG IMAGES DATA
    final productImages = product['images'] as List<dynamic>? ?? [];
    print('🔍 Raw images from API: $productImages');
    
    final allImages = productImages
        .where((img) => img != null && img.toString().trim().isNotEmpty)
        .map((img) => '${ApiConstants.productMediaUrl}${img.toString().trim()}')
        .toList();

    print('📷 Final filtered images for ProductDetail: $allImages');
    print('📷 Images count: ${allImages.length}');

    // 🔹 DEBUG VARIATIONS
    final variations = product['variations'] as List<dynamic>? ?? [];
    print('🎨 Variations count: ${variations.length}');
    for (int i = 0; i < variations.length; i++) {
      final variation = variations[i];
      print('   Variation $i: Size=${variation['size']}, Image=${variation['imageUrl']}');
    }

    final variationsList = variations.map((v) => Map<String, dynamic>.from(v)).toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(
          productId: productId,
          image: mainImageUrl,
          name: productName,
          price: '\$${price.toStringAsFixed(2)}',
          images: allImages, // 🔹 CHỈ HÌNH CỦA PRODUCT
          description: description,
          variations: variationsList,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (topProducts.isEmpty) {
      return Container(
        height: 300,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 151, 195, 216),
          borderRadius: BorderRadius.circular(16),
        ),
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    return Container(
      height: 300, // 🔹 CHIỀU CAO CHUẨN
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 151, 195, 216),
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 🔹 PHẦN HÌNH ẢNH
            Expanded(
              flex: 5, // 🔹 CHIẾM 5/7 KHÔNG GIAN
              child: Stack(
                children: [
                  PageView.builder(
                    controller: pageController,
                    itemCount: 10000,
                    onPageChanged: (index) => goToPage(index),
                    itemBuilder: (context, index) {
                      final int realIndex = index % topProducts.length;
                      final product = topProducts[realIndex];
                      
                      final imageUrl = product['imageUrl'] as String? ?? '';
                      final fullImageUrl = imageUrl.isNotEmpty 
                          ? '${ApiConstants.productMediaUrl}$imageUrl'
                          : '';

                      return GestureDetector(
                        onTap: () => _navigateToProductDetail(context, product),
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: fullImageUrl.isNotEmpty
                                ? Image.network(
                                    fullImageUrl,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                    errorBuilder: (context, error, stackTrace) {
                                      print('❌ Error loading image: $fullImageUrl');
                                      return Container(
                                        color: Colors.grey[200],
                                        child: const Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
                                            SizedBox(height: 8),
                                            Text('Image not found', style: TextStyle(color: Colors.grey, fontSize: 12)),
                                          ],
                                        ),
                                      );
                                    },
                                    loadingBuilder: (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Container(
                                        color: Colors.grey[200],
                                        child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                                      );
                                    },
                                  )
                                : Container(
                                    color: Colors.grey[200],
                                    child: const Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.image, size: 40, color: Colors.grey),
                                        SizedBox(height: 8),
                                        Text('No image', style: TextStyle(color: Colors.grey, fontSize: 12)),
                                      ],
                                    ),
                                  ),
                          ),
                        ),
                      );
                    },
                  ),
                  
                  // Navigation arrows
                  if (topProducts.length > 1) ...[
                    Positioned(
                      left: 0,
                      top: 0,
                      bottom: 0,
                      child: Center(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            shape: BoxShape.circle,
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 4)],
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back_ios_new, size: 16, color: Colors.black),
                            onPressed: () => goToPage(currentPage - 1),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      bottom: 0,
                      child: Center(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            shape: BoxShape.circle,
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 4)],
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black),
                            onPressed: () => goToPage(currentPage + 1),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            
            const SizedBox(height: 12),
            
            // 🔹 THÔNG TIN SẢN PHẨM
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Text(
                    topProducts[currentPage % topProducts.length]['name'] as String? ?? 'Top Product',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${(topProducts[currentPage % topProducts.length]['price'] as double?)?.toStringAsFixed(2) ?? '0.00'}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      Text(
                        'Sold: ${topProducts[currentPage % topProducts.length]['totalQuantitySold'] ?? 0}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 12),
            
            // 🔹 PROGRESS BAR
            Container(
              width: 100,
              height: 3,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
              child: Stack(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 100 * ((currentPage % topProducts.length + 1) / topProducts.length),
                    height: 3,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
