import 'package:do_an_mobile/features/authentication/screens/onboarding/onboarding.dart';
import 'package:do_an_mobile/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:do_an_mobile/controllers/cart_controller.dart'; // 🔹 IMPORT

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
      title: 'MERDI Store',
      // ...existing configuration...

      // 🔹 KHỞI TẠO DEPENDENCIES
      initialBinding: BindingsBuilder(() {
        Get.put(CartController()); // 🔹 ĐĂNG KÝ CART CONTROLLER
      }),

      home: const OnBoardingScreen(), // 🔹 HOẶC WIDGET GỐC CỦA BẠN
    );
  }
}
