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

  const CustomTextField({
    super.key, 
    required this.label, 
    required this.prefixIcon,
    this.isPassword = false,
    this.keyboardType,
    this.validator,
    this.controller,
    this.suffixIcon
    });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: TColors.light,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: TColors.primary.withOpacity(0.1),
            blurRadius: 20,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: keyboardType,
        validator: validator,
        style: TextStyle(
          color: TColors.textPrimary,
          fontSize: TSizes.fontSizeMd,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: TColors.textSecondary,
            fontSize: TSizes.fontSizeSm,
          ),
          prefixIcon: Icon(prefixIcon, color: TColors.primary),
          suffixIcon: suffixIcon ?? (isPassword ? IconButton(
            icon: Icon(Icons.visibility_outlined),
            onPressed: () {},
            color: TColors.primary,
          ) : null),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: TColors.light,
          contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: TColors.primary, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: TColors.secondary.withOpacity(0.1), width: 1),
          ),
        ),
      ),
    );
  }
}