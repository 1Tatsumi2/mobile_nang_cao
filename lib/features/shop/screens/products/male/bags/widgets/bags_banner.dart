// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class TMaleBagsBanner extends StatelessWidget {
  const TMaleBagsBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 250,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Hình ảnh
          Image.asset(
            'assets/images/banner/male_bags_banner.png',
            fit: BoxFit.cover,
          ),
          // 2. Lớp overlay mờ
          Container(
            color: Colors.black.withOpacity(0.2), // Đổi màu và độ mờ nếu muốn
          ),
          // 3. Text ở giữa
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'BAGS FOR MEN',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    letterSpacing: 2,
                    fontFamily: 'Roboto',
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  "The collection of bags for men features duffle bags, briefcases and backpacks in a range of materials and colors.",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.95),
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Roboto',
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
