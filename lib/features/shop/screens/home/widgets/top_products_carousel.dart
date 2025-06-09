// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class TopProductsCarousel extends StatelessWidget {
  final PageController pageController;
  final int currentPage;
  final List<String> productImages;
  final void Function(int) goToPage;

  const TopProductsCarousel({
    super.key,
    required this.pageController,
    required this.currentPage,
    required this.productImages,
    required this.goToPage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 151, 195, 216),
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Stack(
        children: [
          // Overlay phủ toàn bộ khung
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.45),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          // Nội dung carousel và text
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Column(
              children: [
                SizedBox(
                  height: 200,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      PageView.builder(
                        controller: pageController,
                        itemCount: 10000,
                        onPageChanged: (index) => goToPage(index),
                        itemBuilder: (context, index) {
                          final int realIndex = index % productImages.length;
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Image.asset(
                              productImages[realIndex],
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                      ),
                      Positioned(
                        top: 100,
                        left: 55,
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios_new,
                            size: 40,
                            color: Colors.black,
                          ),
                          onPressed: () => goToPage(currentPage - 1),
                        ),
                      ),
                      Positioned(
                        top: 100,
                        right: 55,
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_forward_ios,
                            size: 40,
                            color: Colors.black,
                          ),
                          onPressed: () => goToPage(currentPage + 1),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: SizedBox(
                    width: 200,
                    height: 48,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder:
                          (child, animation) => ScaleTransition(
                            scale: animation,
                            child: FadeTransition(
                              opacity: animation,
                              child: child,
                            ),
                          ),
                      child: Text(
                        [
                          'Woven mini bucket bag',
                          'Gucci Totissima large tote bag',
                          'Gucci Chroma large backpack',
                          'Gucci Chroma large duffle bag',
                          'Gucci Jackie 1961 medium bag',
                        ][currentPage % productImages.length],
                        key: ValueKey(currentPage % productImages.length),
                        style: Theme.of(context).textTheme.titleMedium,
                        textAlign: TextAlign.center,
                        softWrap: true,
                        overflow: TextOverflow.visible,
                        maxLines: 2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 220,
                    child: Stack(
                      children: [
                        // Thanh nền màu xám
                        Container(
                          height: 3,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                        // Thanh tiến độ màu trắng
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final progress =
                                (currentPage % productImages.length + 1) /
                                productImages.length;
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeInOut,
                              height: 3,
                              width: constraints.maxWidth * progress,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(3),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
