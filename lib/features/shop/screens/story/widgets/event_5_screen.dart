// ignore_for_file: camel_case_types, deprecated_member_use

import 'package:flutter/material.dart';

class eventFive extends StatelessWidget {
  final String image;
  final String title;

  const eventFive({super.key, required this.image, required this.title});

  final String firstImage = 'assets/images/event/fashion.png';
  final String secondImage = 'assets/images/event/anh20.png';
  final String thirdImage = 'assets/images/event/anh21.png';
  final String fourthImage = 'assets/images/event/anh22.png';
  final String fifthImage = 'assets/images/event/anh23.png';
  final String sixthImage = 'assets/images/event/anh2.png';

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
                            'CRUISE 2025 FASHION SHOW',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.5,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const Center(
                          child: Text(
                            'Experience the spectacle of the Cruise 2025 Fashion Show, where heritage meets contemporary luxury in an unforgettable presentation.',
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
                            'Discover the Cruise 2025 collection where timeless elegance meets contemporary innovation, creating pieces that embody the spirit of modern luxury.',
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
                        // Ảnh 3
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
                        const Center(
                          child: Text(
                            'BEHIND THE SCENES',
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
                            'Go behind the scenes of the Cruise 2025 fashion show. Witness the artistry, dedication, and creative process that brings each collection to life.',
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
                        // Ảnh 4
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
                        const Center(
                          child: Text(
                            'SHOW EXPERIENCE',
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
                            'Immerse yourself in the complete fashion show experience. From the runway atmosphere to the finest details, discover what makes each show unforgettable.',
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
                            'Take a closer look at the intricate details and craftsmanship that define the Cruise 2025 collection. Every element tells a story of luxury and innovation.',
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
                        const SizedBox(height: 24),
                        const Center(
                          child: Text(
                            'RUNWAY MOMENTS',
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
                            'Capture the most memorable runway moments from the Cruise 2025 show. Each look represents a perfect harmony between tradition and innovation.',
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

