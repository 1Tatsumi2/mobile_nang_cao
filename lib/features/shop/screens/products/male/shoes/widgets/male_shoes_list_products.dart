import 'package:do_an_mobile/features/shop/screens/products/product_detail/product_detail_screen.dart';
import 'package:do_an_mobile/utils/constants/colors.dart';
import 'package:do_an_mobile/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class TMaleShoesListProducts extends StatelessWidget {
  final List<Map<String, dynamic>> products; // Sửa lại kiểu này!
  const TMaleShoesListProducts({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.zero,
        child: GridView.builder(
          padding: EdgeInsets.zero, // Thêm dòng này!
          itemCount: products.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 0,
            crossAxisSpacing: 0,
            childAspectRatio: 0.8,
          ),
          itemBuilder: (context, index) {
            final product = products[index];
            return _MaleProductCard(
              image: product['image']!,
              name: product['name']!,
              price: '\$${product['price']}',
              images: List<String>.from(
                product['images'] ?? [],
              ), // Thêm dòng này!
            );
          },
        ),
      ),
    );
  }
}

class _MaleProductCard extends StatefulWidget {
  final String image;
  final String name;
  final String price;
  final List<String>? images;

  const _MaleProductCard({
    required this.image,
    required this.name,
    required this.price,
    this.images, // Thêm trường này nếu cần truyền nhiều ảnh
  });

  @override
  State<_MaleProductCard> createState() => _MaleProductCardState();
}

class _MaleProductCardState extends State<_MaleProductCard> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (_) => ProductDetailScreen(
                  image: widget.image,
                  name: widget.name,
                  price: widget.price,
                  images: widget.images, // <-- Truyền thêm dòng này
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
                    child: Image.asset(widget.image, fit: BoxFit.contain),
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
          // Icon trái tim ở góc trên bên phải
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
