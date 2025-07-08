import 'package:do_an_mobile/features/shop/screens/products/product_detail/product_detail_screen.dart';
import 'package:do_an_mobile/features/shop/controllers/wishlist_controller.dart';
import 'package:do_an_mobile/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:collection';

class TListProducts extends StatelessWidget {
  final List<Map<String, dynamic>> products;
  final String imageBaseUrl;

  const TListProducts({
    super.key,
    required this.products,
    required this.imageBaseUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.zero,
        child: GridView.builder(
          padding: EdgeInsets.zero,
          itemCount: products.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 0,
            crossAxisSpacing: 0,
            childAspectRatio: 0.8,
          ),
          itemBuilder: (context, index) {
            final product = products[index];
            final imageUrl =
                product['image'] != null && product['image'] != ''
                    ? '$imageBaseUrl${product['image']}'
                    : '';
            final image2Url =
                product['image2'] != null && product['image2'] != ''
                    ? '$imageBaseUrl${product['image2']}'
                    : null;

            final images = <String>[
              if (imageUrl.isNotEmpty) imageUrl,
              if (image2Url != null && image2Url.isNotEmpty) image2Url,
              if (product['images'] != null)
                ...List<String>.from(
                  product['images'].map((img) => '$imageBaseUrl$img'),
                ),
            ];

            return _ProductCard(
              image: imageUrl,
              name: product['name'] ?? '',
              price: '\$${product['price']}',
              images: images,
              description: product['description'] ?? '',
              variations:
                  product['variations'] != null
                      ? List<Map<String, dynamic>>.from(product['variations'])
                      : [],
              productId: product['id'], // 🔹 ĐẢM BẢO TRUYỀN ĐÚNG ID
            );
          },
        ),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final String image;
  final String name;
  final String price;
  final List<String> images;
  final String description;
  final List<Map<String, dynamic>> variations;
  final int productId; // Đảm bảo có field này

  const _ProductCard({
    required this.image,
    required this.name,
    required this.price,
    required this.images,
    required this.description,
    required this.variations,
    required this.productId,
  });

  @override
  Widget build(BuildContext context) {
    final wishlistController = Get.put(WishlistController());

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (_) => ProductDetailScreen(
                  productId: productId, // 🔹 THÊM DÒNG NÀY
                  image: image,
                  name: name,
                  price: price,
                  images: images,
                  description: description,
                  variations: variations,
                ),
          ),
        );
      },
      child: Stack(
        children: [
          Card(
            elevation: 0,
            color: Colors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
              side: BorderSide(color: Color(0xFFE0E0E0), width: 1),
            ),
            margin: EdgeInsets.zero,
            child: Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 120,
                    child: Image.network(image, fit: BoxFit.contain),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    price,
                    style: const TextStyle(
                      color: TColors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: TColors.black, width: 1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'SHOP THIS',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: TColors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // WISHLIST ICON
          Positioned(
            top: 12,
            right: 16,
            child: Obx(() {
              bool isFav = wishlistController.isFavorite(productId);
              return IconButton(
                icon: Icon(
                  isFav ? Icons.favorite : Icons.favorite_border,
                  color: isFav ? Colors.red : TColors.black,
                ),
                onPressed: () {
                  print('🔥 Clicked heart for: $name (productId: $productId)');
                  print('🖼️ All images being passed: $images'); // 🔹 DEBUG

                  wishlistController.toggleWishlist(
                    productId,
                    productName: name,
                    price:
                        double.tryParse(
                          price.replaceAll('\$', '').replaceAll(',', ''),
                        ) ??
                        0.0,
                    image: image, // Primary image
                    images: images, // 🔹 TRUYỀN TẤT CẢ IMAGES
                    description: description,
                    variations: variations,
                  );
                },
                iconSize: 24,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class TListProductsGrid extends StatelessWidget {
  final List<Map<String, dynamic>> products;
  final String imageBaseUrl;

  const TListProductsGrid({
    super.key,
    required this.products,
    required this.imageBaseUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.zero,
      child: GridView.builder(
        padding: EdgeInsets.zero,
        itemCount: products.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 0,
          crossAxisSpacing: 0,
          childAspectRatio: 0.8,
        ),
        itemBuilder: (context, index) {
          final product = products[index];

          // 🔹 XỬ LÝ AN TOÀN HỖN
          String primaryImage = '';
          if (product['image'] != null &&
              product['image'].toString().isNotEmpty) {
            primaryImage = product['image'].toString();
            // Nếu chưa có baseUrl thì thêm vào
            if (!primaryImage.startsWith('http')) {
              primaryImage = '$imageBaseUrl$primaryImage';
            }
          }

          // 🔹 XỬ LÝ IMAGE2 AN TOÀN
          String? secondaryImage;
          if (product['image2'] != null &&
              product['image2'].toString().isNotEmpty) {
            secondaryImage = product['image2'].toString();
            if (!secondaryImage.startsWith('http')) {
              secondaryImage = '$imageBaseUrl$secondaryImage';
            }
          }

          // 🔹 XỬ LÝ IMAGES ARRAY AN TOÀN
          List<String> additionalImages = [];
          if (product['images'] != null) {
            try {
              final imagesList = product['images'];
              if (imagesList is List) {
                for (var img in imagesList) {
                  if (img != null && img.toString().isNotEmpty) {
                    String imgUrl = img.toString();
                    if (!imgUrl.startsWith('http')) {
                      imgUrl = '$imageBaseUrl$imgUrl';
                    }
                    additionalImages.add(imgUrl);
                  }
                }
              }
            } catch (e) {
              print('💥 Error processing images array: $e');
            }
          }

          // 🔹 GOM TẤT CẢ IMAGES VÀ LOẠI BỎ DUPLICATE
          final allImages = <String>[
            if (primaryImage.isNotEmpty) primaryImage,
            if (secondaryImage != null && secondaryImage.isNotEmpty)
              secondaryImage,
            ...additionalImages,
          ];

          // 🔹 LOẠI BỎ DUPLICATE BẰNG LinkedHashSet (giữ thứ tự)
          final images = LinkedHashSet<String>.from(allImages).toList();

          // 🔹 FALLBACK NẾU KHÔNG CÓ IMAGES
          if (images.isEmpty) {
            images.add('https://via.placeholder.com/300x300?text=No+Image');
          }

          print('🖼️ Final images for product ${product['id']}: $images');

          return _ProductCard(
            image:
                images.isNotEmpty
                    ? images.first
                    : 'https://via.placeholder.com/300x300?text=No+Image',
            name: product['name'] ?? 'Unknown Product',
            price: '\$${product['price'] ?? 0}',
            images: images,
            description: product['description'] ?? '',
            variations:
                product['variations'] != null
                    ? List<Map<String, dynamic>>.from(product['variations'])
                    : [],
            productId: product['id'] ?? 0,
          );
        },
      ),
    );
  }
}
