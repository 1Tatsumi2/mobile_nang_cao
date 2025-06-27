// ignore_for_file: deprecated_member_use

import 'package:do_an_mobile/utils/constants/colors.dart';
import 'package:do_an_mobile/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget{
  final String label;
  final IconData prefixIcon;
  final bool isPassword;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final Widget? suffixIcon;
  final bool enabled; // ← THÊM PARAMETER NÀY

  const CustomTextField({
    super.key, 
    required this.label, 
    required this.prefixIcon,
    this.isPassword = false,
    this.keyboardType,
    this.validator,
    this.controller,
    this.suffixIcon,
    this.enabled = true, // ← THÊM DEFAULT VALUE
    });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16), // ← THÊM const
      decoration: BoxDecoration(
        color: enabled ? TColors.light : TColors.lightGrey, // ← THAY ĐỔI MÀU KHI DISABLED
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: TColors.primary.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 5), // ← THÊM const
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        enabled: enabled, // ← SỬ DỤNG PARAMETER
        obscureText: isPassword,
        keyboardType: keyboardType,
        validator: validator,
        style: TextStyle(
          color: enabled ? TColors.textPrimary : TColors.grey, // ← THAY ĐỔI MÀU TEXT
          fontSize: TSizes.fontSizeMd,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: enabled ? TColors.textSecondary : TColors.grey, // ← THAY ĐỔI MÀU LABEL
            fontSize: TSizes.fontSizeSm,
          ),
          prefixIcon: Icon(
            prefixIcon, 
            color: enabled ? TColors.primary : TColors.grey, // ← THAY ĐỔI MÀU ICON
          ),
          suffixIcon: suffixIcon ?? (isPassword ? IconButton(
            icon: const Icon(Icons.visibility_outlined), // ← THÊM const
            onPressed: enabled ? () {} : null, // ← DISABLE KHI enabled = false
            color: enabled ? TColors.primary : TColors.grey,
          ) : null),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: enabled ? TColors.light : TColors.lightGrey, // ← THAY ĐỔI MÀU NỀN
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20), // ← THÊM const
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: enabled ? TColors.primary : TColors.grey, 
              width: 2,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: TColors.secondary.withOpacity(0.1), 
              width: 1,
            ),
          ),
          disabledBorder: OutlineInputBorder( // ← THÊM DISABLED BORDER
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: TColors.grey.withOpacity(0.3), 
              width: 1,
            ),
          ),
        ),
      ),
    );
  }
}