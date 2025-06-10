// ignore_for_file: deprecated_member_use

import 'package:do_an_mobile/features/shop/screens/home/home.dart';

import 'package:do_an_mobile/features/shop/screens/story/story.dart';

import 'package:do_an_mobile/features/shop/screens/profile/widget/profile_screen.dart';

import 'package:do_an_mobile/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    final darkMode = THelperFunctions.isDarkMode(context);

    return Scaffold(
      extendBody: true,
      bottomNavigationBar: Container(
        color: Colors.transparent,
        child: Obx(
          () => Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 15),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(37.5),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: Container(
                  height: 75,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(37.5),
                    color:
                        darkMode
                            ? Colors.grey.shade900.withOpacity(0.7)
                            : Colors.grey.shade300.withOpacity(0.7),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(37.5),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(37.5),
                          border: Border.all(
                            color:
                                darkMode
                                    ? Colors.grey.shade800.withOpacity(0.5)
                                    : Colors.grey.shade400.withOpacity(0.5),
                            width: 0.5,
                          ),
                        ),
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                          ),
                          child: NavigationBar(
                            height: 75,
                            elevation: 0,
                            selectedIndex: controller.selectedIndex.value,
                            onDestinationSelected:
                                (index) =>
                                    controller.selectedIndex.value = index,
                            backgroundColor: Colors.transparent,
                            surfaceTintColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            indicatorColor:
                                darkMode
                                    ? Colors.white.withOpacity(0.1)
                                    : Colors.black.withOpacity(0.08),
                            labelBehavior:
                                NavigationDestinationLabelBehavior
                                    .onlyShowSelected,
                            destinations: [
                              NavigationDestination(
                                icon: Icon(
                                  Iconsax.home,
                                  color: darkMode ? Colors.white : Colors.black,
                                ),
                                label: 'Home',
                              ),
                              NavigationDestination(
                                icon: Icon(
                                  Iconsax.shop,
                                  color: darkMode ? Colors.white : Colors.black,
                                ),
                                label: 'Store',
                              ),
                              NavigationDestination(
                                icon: Icon(
                                  Iconsax.heart,
                                  color: darkMode ? Colors.white : Colors.black,
                                ),
                                label: 'Wishlist',
                              ),
                              NavigationDestination(
                                icon: Icon(
                                  Iconsax.user,
                                  color: darkMode ? Colors.white : Colors.black,
                                ),
                                label: 'Profile',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final screens = [
    const HomeScreen(),
    const StoryScreen(),
    Container(color: Colors.orange),
    const ProfileScreen(),
  ];
}
