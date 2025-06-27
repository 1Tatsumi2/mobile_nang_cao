import 'package:do_an_mobile/features/authentication/screens/onboarding/onboarding.dart';
import 'package:do_an_mobile/features/shop/screens/cart/widgets/order_tracking_screen.dart';
import 'package:do_an_mobile/features/shop/screens/home/home.dart';
import 'package:do_an_mobile/features/shop/screens/profile/widget/profile_order_screen.dart';
import 'package:do_an_mobile/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';


/// ---------------- Entry point of Flutter App ----------------

void main() {
  // Todo: Add Widgets Binding
  // Todo: Init Local Storage
  // Todo: Await Native Splash
  // Todo: Initialize Firebase
  // Todo: Initialize Authentication

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      home: const OnBoardingScreen(),
    );
  }
}
