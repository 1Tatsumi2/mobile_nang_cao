import 'package:do_an_mobile/features/story/screens/event_1_screen.dart';
import 'package:do_an_mobile/features/story/screens/event_2_screen.dart';
import 'package:do_an_mobile/features/story/screens/event_3_screen.dart';
import 'package:do_an_mobile/features/story/screens/event_4_screen.dart';
import 'package:do_an_mobile/features/story/screens/event_5_screen.dart';
import 'package:flutter/material.dart';

class StoryScreen extends StatelessWidget {
  const StoryScreen({super.key});

  final List<String> images = const <String>[
    'assets/images/event/Cruise2026.png',
    'assets/images/event/Fallwinter2025.png',
    'assets/images/event/women2025.png',
    'assets/images/event/men.png',
    'assets/images/event/fashion.png',
  ];

  final List<String> titles = const <String>[
    'Cruise 2026',
    'Fall Winter 2025',
    'Women Spring Summer 2025',
    'Men Spring Summer 2025',
    'Cruise 2026 Fashion Show',
  ];

  @override
  Widget build(BuildContext context) {
    final double bannerHeight =
        MediaQuery.of(context).size.height -
        (MediaQuery.of(context).padding.top + 180);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: List.generate(
          images.length,
          (index) => GestureDetector(
            onTap: () {
              switch (index) {
                case 0:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => const eventOne(
                            image: 'assets/images/banner/Cruise2026.png',
                            title: 'Cruise 2026',
                          ),
                    ),
                  );
                  break;
                case 1:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => const eventTwo(
                            image: 'assets/images/banner/Fallwinter2025.png',
                            title: 'Fall Winter 2025',
                          ),
                    ),
                  );
                  break;
                case 2:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => const eventThree(
                            image: 'assets/images/banner/women2025.png',
                            title: 'Women Spring Summer 2025',
                          ),
                    ),
                  );
                  break;
                case 3:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => const eventFour(
                            image: 'assets/images/banner/men.png',
                            title: 'Men Spring Summer 2025',
                          ),
                    ),
                  );
                  break;
                case 4:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => const eventFive(
                            image: 'assets/images/banner/fashion.png',
                            title: 'Cruise 2026 Fashion Show',
                          ),
                    ),
                  );
                  break;
              }
            },
            child: Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: bannerHeight,
                  child: Image.asset(
                    images[index],
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: bannerHeight,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.3),
                        Colors.black.withOpacity(0.5),
                      ],
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        titles[index],
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 24,
                          fontWeight: FontWeight.w300,
                          color: Colors.white,
                          letterSpacing: 1,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
