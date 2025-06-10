// ignore_for_file: deprecated_member_use, camel_case_types

import 'package:flutter/material.dart';

class eventOne extends StatelessWidget {
  final String image;
  final String title;

  const eventOne({super.key, required this.image, required this.title});

  final String firstImage = 'assets/images/event/anh1.png';
  final String secondImage = 'assets/images/event/anh2.png';
  final String thirdImage = 'assets/images/event/anh3.png';
  final String fourthImage = 'assets/images/event/anh4.png';
  final String fifthImage = 'assets/images/event/anh5.png';
  final String sixthImage = 'assets/images/event/anh6.png';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ScrollConfiguration(
            behavior: ScrollConfiguration.of(
              context,
            ).copyWith(scrollbars: false),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Ảnh 1
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.85,
                    child: Image.asset(
                      firstImage,
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 16.0,
                    ),
                    child: Column(
                      children: [
                        const Center(
                          child: Text(
                            'For the cruise 2026 fashion show, the house returned to its birthplace of florence, presenting the new collection at the Gucci archive.',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              color: Colors.black87,
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero,
                                side: const BorderSide(
                                  color: Colors.black,
                                  width: 1,
                                ),
                              ),
                            ),
                            child: const Text(
                              'DISCOVER MORE',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        // Ảnh 2
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.85,
                          child: Image.asset(
                            secondImage,
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.width,
                            alignment: Alignment.center,
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Center(
                          child: Text(
                            'THE COLLECTION',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.5,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Center(
                          child: Text(
                            'Discover the latest Cruise 2026 collection, featuring innovative designs that blend Italian craftsmanship with contemporary elegance.',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              color: Colors.black87,
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 32), // Ảnh 3
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.85,
                          child: Image.asset(
                            thirdImage,
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.width,
                            alignment: Alignment.center,
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Tiêu đề Gucci Giglio
                        const Center(
                          child: Text(
                            'GUCCI GIGLIO',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.5,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Center(
                          child: Text(
                            'Experience the iconic Gucci Giglio, a symbol of the house heritage reimagined for the modern era with sophisticated details.',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              color: Colors.black87,
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 32), // Ảnh 4
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.85,
                          child: Image.asset(
                            fourthImage,
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.width,
                            alignment: Alignment.center,
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Tiêu đề CRUISE 2026
                        const Center(
                          child: Text(
                            'CRUISE 2026',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.5,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Center(
                          child: Text(
                            'A celebration of craftsmanship and innovation, the Cruise 2026 collection represents the perfect fusion of tradition and modernity in luxury fashion.',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              color: Colors.black87,
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 32),
                        // Ảnh 5
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.85,
                          child: Image.asset(
                            fifthImage,
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.width,
                            alignment: Alignment.center,
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Tiêu đề CLOSER LOOK
                        const Center(
                          child: Text(
                            'CLOSER LOOK',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.5,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Center(
                          child: Text(
                            'Explore the intricate details and exceptional craftsmanship that define each piece in the Cruise 2026 collection.',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              color: Colors.black87,
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 32),
                        // Ảnh 6
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.85,
                          child: Image.asset(
                            sixthImage,
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.width,
                            alignment: Alignment.center,
                          ),
                        ),
                        const SizedBox(
                          height: 24,
                        ), // Tiêu đề MAKEUP AT THE SHOW
                        const Center(
                          child: Text(
                            'MAKEUP AT THE SHOW',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.5,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Center(
                          child: Text(
                            'Discover the exclusive beauty looks created for the Cruise 2026 show, featuring innovative makeup artistry that complements the collection.',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              color: Colors.black87,
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 32,
            right: 16,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black.withOpacity(0.2),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(20),
                color: Colors.white.withOpacity(0.8),
              ),
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.black, size: 16),
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                padding: EdgeInsets.zero,
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
