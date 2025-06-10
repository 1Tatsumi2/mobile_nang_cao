// ignore_for_file: deprecated_member_use

import 'package:do_an_mobile/features/shop/screens/products/female/female_products_screen.dart';
import 'package:do_an_mobile/features/shop/screens/products/male/male_products_screen.dart';
import 'package:do_an_mobile/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class TBanner extends StatelessWidget {
  const TBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height:
              MediaQuery.of(context).size.height -
              (MediaQuery.of(context).padding.top + 180),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/banner/home_banner.png'),
              fit: BoxFit.cover,
              alignment: Alignment(-0.4, 0.0),
            ),
          ),
        ),
        Container(
          width: double.infinity,
          height:
              MediaQuery.of(context).size.height -
              (MediaQuery.of(context).padding.top + 180),
          color: Colors.black.withOpacity(0.2),
        ),
        Positioned.fill(
          child: Stack(
            children: [
              Align(
                alignment: const Alignment(0, -0.6),
                child: const Text(
                  'MERDI',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 90,
                    letterSpacing: 20,
                    fontFamily: 'Roboto',
                  ),
                ),
              ),
              Align(
                alignment: const Alignment(0, 0.4),
                child: const Text(
                  'Merdi Lido',
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
              ),
              Align(
                alignment: const Alignment(0, 0.7), // 👈 thấp hơn dòng chữ
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildWhiteBox('FOR HER', () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FemaleProductsScreen(),
                        ),
                      );
                    }),
                    const SizedBox(width: 16),
                    _buildWhiteBox('FOR HIM', () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MaleProductsScreen(),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

Widget _buildWhiteBox(String text, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(TSizes.borderRadiusSm),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    ),
  );
}
