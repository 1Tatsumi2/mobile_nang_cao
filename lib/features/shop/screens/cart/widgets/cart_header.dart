import 'package:flutter/material.dart';

class CartHeader extends StatelessWidget {
  const CartHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          'assets/images/banner/home_banner.png',
          width: double.infinity,
          height: 200,
          fit: BoxFit.cover,
        ),
        // Overlay để làm tối ảnh
        Container(
          width: double.infinity,
          height: 200,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.3),
                Colors.black.withOpacity(0.6),
              ],
            ),
          ),
        ),
        // Text căn giữa
        const Positioned.fill(
          child: Center(
            child: Text(
              'SHOPPING BAG',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
                shadows: [
                  Shadow(
                    offset: Offset(2, 2),
                    blurRadius: 4,
                    color: Colors.black54,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
