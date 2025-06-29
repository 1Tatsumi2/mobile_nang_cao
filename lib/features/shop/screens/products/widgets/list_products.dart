import 'package:do_an_mobile/features/shop/screens/products/product_detail/product_detail_screen.dart';
import 'package:do_an_mobile/utils/constants/colors.dart';
import 'package:do_an_mobile/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

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
            final imageUrl = product['image'] != null
                ? '$imageBaseUrl${product['image']}'
                : '';
            final image2Url = product['image2'] != null && product['image2'] != ''
                ? '$imageBaseUrl${product['image2']}'
                : null;

            // Gom tất cả ảnh vào 1 list
            final images = <String>[
              if (imageUrl.isNotEmpty) imageUrl,
              if (image2Url != null && image2Url.isNotEmpty) image2Url,
              // Nếu có mảng images thì thêm vào
              if (product['images'] != null)
                ...List<String>.from(product['images'].map((img) => '$imageBaseUrl$img')),
            ];

            return _ProductCard(
              image: imageUrl,
              name: product['name'] ?? '',
              price: '\$${product['price']}',
              images: images,
              description: product['description'] ?? '',
              variations: product['variations'] != null
                  ? List<Map<String, dynamic>>.from(product['variations'])
                  : [],
              productId: product['id'], // Thêm dòng này
            );
          },
        ),
      ),
    );
  }
}

class _ProductCard extends StatefulWidget {
  final int productId; // Thêm dòng này
  final String image;
  final String name;
  final String price;
  final List<String>? images;
  final String? description;
  final List<Map<String, dynamic>>? variations;

  const _ProductCard({
    required this.productId, // Thêm dòng này
    required this.image,
    required this.name,
    required this.price,
    this.images,
    this.description,
    this.variations,
  });

  @override
  State<_ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<_ProductCard> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailScreen(
              productId: widget.productId, // Thêm dòng này
              image: widget.image,
              name: widget.name,
              price: widget.price,
              images: widget.images,
              description: widget.description,
              variations: widget.variations,
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
                    child: Image.network(widget.image, fit: BoxFit.contain),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.price,
                    style: const TextStyle(
                      color: TColors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems / 2),
                  InkWell(
                    onTap: () {},
                    child: const Text(
                      'SHOP THIS',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 12,
            right: 16,
            child: IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : TColors.black,
              ),
              onPressed: () {
                setState(() {
                  isFavorite = !isFavorite;
                });
              },
              iconSize: 24,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ),
        ],
      ),
    );
  }
}