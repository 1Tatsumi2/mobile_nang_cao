// ignore_for_file: camel_case_types, deprecated_member_use

import 'package:flutter/material.dart';

class eventFour extends StatelessWidget {
  final String image;
  final String title;

  const eventFour({super.key, required this.image, required this.title});

  final String firstImage = 'assets/images/event/men.png';
  final String secondImage = 'assets/images/event/anh15.png';
  final String thirdImage = 'assets/images/event/anh16.png';
  final String fourthImage = 'assets/images/event/anh17.png';
  final String fifthImage = 'assets/images/event/anh18.png';
  final String sixthImage = 'assets/images/event/anh19.png';

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
                        const Text(
                          'MENS SPRING SUMMER 2025 FASHION SHOW',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.5,
                            color: Colors.black,
                          ),
                        ),
                        const Center(
                          child: Text(
                            'The House revealed the Spring Summer 2025 mens fashion show at Triennale Milano, a cultural space in the heart of the city where creativity flourishes through new encounters. Dedicated to design, architecture and performing arts, this special place welcomed Creative Director Sabato De Sarnos continued exploration of the shared essence between art and fashion.',
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
                            'Discover the menswear Spring Summer 2025 collection that explores the synergy between art and fashion, showcasing contemporary masculinity through innovative design.',
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
                            'SPRING SUMMER 2025',
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
                            'Contemporary menswear that bridges traditional craftsmanship with modern innovation. Each piece embodies the essence of Italian elegance and artistic vision.',
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
                            'ABOUT THE SHOW',
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
                            'At Triennale Milano, creativity meets fashion. This cultural space welcomed the mens Spring Summer 2025 collection, showcasing the perfect intersection of design and art.',
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
                            'IN DETAIL',
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
                            'Exquisite details that define luxury menswear. From precise tailoring to innovative textures, every element reflects the Houses commitment to excellence and artistry.',
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
                            'FRIENDS OF THE HOUSE',
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
                            'Celebrating the community that embodies the spirit of Gucci. Friends of the House represent the diverse voices and creative talents that inspire our vision.',
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
