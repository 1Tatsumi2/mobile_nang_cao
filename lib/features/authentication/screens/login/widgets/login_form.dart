// ignore_for_file: use_build_context_synchronously

import 'package:do_an_mobile/features/authentication/screens/password_configuration/forget_password.dart';
import 'package:do_an_mobile/features/authentication/screens/signup/signup.dart';
import 'package:do_an_mobile/navigation_menu.dart';
import 'package:do_an_mobile/services/auth_service.dart';
import 'package:do_an_mobile/utils/constants/sizes.dart';
import 'package:do_an_mobile/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class TLoginForm extends StatefulWidget {
  const TLoginForm({super.key});

  @override
  State<TLoginForm> createState() => _TLoginFormState();
}

class _TLoginFormState extends State<TLoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isPasswordVisible = false; // 🔹 THÊM BIẾN ĐIỀU KHIỂN HIỂN THỊ PASSWORD
  bool _rememberMe = false; // 🔹 THÊM BIẾN REMEMBER ME

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: TSizes.spaceBtwSections),
        child: Column(
          children: [
            /// Email/Username
            TextFormField(
              controller: _usernameController,
              enabled: !_isLoading, // 🔹 DISABLE KHI ĐANG LOADING
              decoration: const InputDecoration(
                prefixIcon: Icon(Iconsax.direct_right),
                labelText: TTexts.email,
              ),
              validator: (value) => value == null || value.isEmpty ? 'Enter username or email' : null,
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),

            /// Password
            TextFormField(
              controller: _passwordController,
              enabled: !_isLoading, // 🔹 DISABLE KHI ĐANG LOADING
              obscureText: !_isPasswordVisible, // 🔹 SỬA LẠI: ĐIỀU KHIỂN BẰNG BIẾN
              decoration: InputDecoration(
                prefixIcon: const Icon(Iconsax.password_check),
                labelText: TTexts.password,
                suffixIcon: IconButton( // 🔹 SỬA LẠI: DÙNG ICONBUTTON
                  icon: Icon(
                    _isPasswordVisible ? Iconsax.eye : Iconsax.eye_slash,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
              ),
              validator: (value) => value == null || value.isEmpty ? 'Enter password' : null,
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields / 2),

            /// Remember me & Forgot Password
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// Remember me
                Row(
                  children: [
                    Checkbox(
                      value: _rememberMe, // 🔹 SỬA LẠI: DÙNG BIẾN
                      onChanged: _isLoading ? null : (value) { // 🔹 DISABLE KHI LOADING
                        setState(() {
                          _rememberMe = value ?? false;
                        });
                      },
                    ),
                    const Text(TTexts.rememberMe),
                  ],
                ),

                /// Forgot Password
                TextButton(
                  onPressed: _isLoading ? null : () => Get.to(() => const ForgetPassword()), // 🔹 DISABLE KHI LOADING
                  child: const Text(TTexts.forgotPassword),
                ),
              ],
            ),
            const SizedBox(height: TSizes.spaceBtwSections),

            /// Sign In Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleLogin, // 🔹 EXTRACT THÀNH METHOD RIÊNG
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(TTexts.signIn),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwItems),

            /// Create Account Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: _isLoading ? null : () => Get.to(() => const SignupScreen()), // 🔹 DISABLE KHI LOADING
                child: const Text(TTexts.createAccount),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 EXTRACT LOGIN LOGIC THÀNH METHOD RIÊNG
  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    
    try {
      final result = await AuthService.login(
        _usernameController.text.trim(),
        _passwordController.text,
      );
      
      if (result['success'] == true) {
        // 🔹 ĐĂNG NHẬP THÀNH CÔNG
        Get.snackbar(
          'Success',
          'Welcome back!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
        
        // Chuyển trang sau khi hiển thị thông báo
        Future.delayed(const Duration(milliseconds: 500), () {
          Get.offAll(() => const NavigationMenu());
        });
      } else {
        // 🔹 ĐĂNG NHẬP THẤT BẠI
        Get.snackbar(
          'Login Failed',
          result['message'] ?? 'Invalid username or password',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      // 🔹 LỖI NETWORK HOẶC EXCEPTION
      Get.snackbar(
        'Error',
        'An error occurred: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
