import 'package:do_an_mobile/features/authentication/screens/signup/widgets/terms_conditions_checkbox.dart';
import 'package:do_an_mobile/services/auth_service.dart';
import 'package:do_an_mobile/utils/constants/sizes.dart';
import 'package:do_an_mobile/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class TSignupForm extends StatefulWidget {
  const TSignupForm({super.key});

  @override
  State<TSignupForm> createState() => _TSignupFormState();
}

class _TSignupFormState extends State<TSignupForm> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isPasswordVisible = false; // 🔹 THÊM BIẾN ĐIỀU KHIỂN HIỂN THỊ PASSWORD

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          /// First Name & Last Name
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _firstNameController,
                  enabled: !_isLoading, // 🔹 DISABLE KHI ĐANG LOADING
                  decoration: const InputDecoration(
                    labelText: TTexts.firstName,
                    prefixIcon: Icon(Iconsax.user),
                  ),
                  validator: (value) => value == null || value.isEmpty ? 'Enter first name' : null,
                ),
              ),
              const SizedBox(width: TSizes.spaceBtwInputFields),
              Expanded(
                child: TextFormField(
                  controller: _lastNameController,
                  enabled: !_isLoading, // 🔹 DISABLE KHI ĐANG LOADING
                  decoration: const InputDecoration(
                    labelText: TTexts.lastName,
                    prefixIcon: Icon(Iconsax.user),
                  ),
                  validator: (value) => value == null || value.isEmpty ? 'Enter last name' : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),

          /// Username
          TextFormField(
            controller: _usernameController,
            enabled: !_isLoading, // 🔹 DISABLE KHI ĐANG LOADING
            decoration: const InputDecoration(
              labelText: TTexts.username,
              prefixIcon: Icon(Iconsax.user_edit),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Enter username';
              if (value.length < 3) return 'Username must be at least 3 characters';
              return null;
            },
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),

          /// Email
          TextFormField(
            controller: _emailController,
            enabled: !_isLoading, // 🔹 DISABLE KHI ĐANG LOADING
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: TTexts.email,
              prefixIcon: Icon(Iconsax.direct),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Enter email';
              if (!GetUtils.isEmail(value)) return 'Enter a valid email';
              return null;
            },
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),

          /// Phone Number
          TextFormField(
            controller: _phoneController,
            enabled: !_isLoading, // 🔹 DISABLE KHI ĐANG LOADING
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              labelText: TTexts.phoneNumber,
              prefixIcon: Icon(Iconsax.call),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Enter phone number';
              if (value.length < 10) return 'Enter a valid phone number';
              return null;
            },
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),

          /// Password
          TextFormField(
            controller: _passwordController,
            enabled: !_isLoading, // 🔹 DISABLE KHI ĐANG LOADING
            obscureText: !_isPasswordVisible, // 🔹 SỬA LẠI: ĐIỀU KHIỂN BẰNG BIẾN
            decoration: InputDecoration(
              labelText: TTexts.password,
              prefixIcon: const Icon(Iconsax.password_check),
              suffixIcon: IconButton( // 🔹 SỬA LẠI: DÙNG ICONBUTTON
                icon: Icon(
                  _isPasswordVisible ? Iconsax.eye : Iconsax.eye_slash,
                ),
                onPressed: _isLoading ? null : () { // 🔹 DISABLE KHI LOADING
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Enter password';
              if (value.length < 6) return 'Password must be at least 6 characters';
              return null;
            },
          ),
          const SizedBox(height: TSizes.spaceBtwSections),

          /// Terms&Conditions Checkbox
          const TTermsAndConditionCheckbox(),
          const SizedBox(height: TSizes.spaceBtwSections),

          /// Sign Up Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _handleSignup, // 🔹 EXTRACT THÀNH METHOD RIÊNG
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(TTexts.createAccount),
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 EXTRACT SIGNUP LOGIC THÀNH METHOD RIÊNG
  Future<void> _handleSignup() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    
    try {
      // 🔹 TẠO USERNAME TỪ FIRST NAME + LAST NAME
      final fullName = '${_firstNameController.text.trim()} ${_lastNameController.text.trim()}';
      final username = _usernameController.text.trim().isNotEmpty 
          ? _usernameController.text.trim()
          : fullName.replaceAll(' ', '').toLowerCase();

      final result = await AuthService.register(
        username: username,
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        password: _passwordController.text,
      );
      
      if (result['success'] == true) {
        // 🔹 ĐĂNG KÝ THÀNH CÔNG
        Get.snackbar(
          'Success',
          result['message'] ?? 'Account created successfully!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
        
        // Quay lại trang login sau khi đăng ký thành công
        Future.delayed(const Duration(seconds: 1), () {
          Get.back(); // Quay lại login screen
        });
      } else {
        // 🔹 ĐĂNG KÝ THẤT BẠI
        Get.snackbar(
          'Registration Failed',
          result['message'] ?? 'Failed to create account',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 4),
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
