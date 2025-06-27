// ignore_for_file: deprecated_member_use, use_key_in_widget_constructors

import 'package:do_an_mobile/utils/constants/colors.dart';
import 'package:do_an_mobile/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget{
  final String text;
  final VoidCallback onPressed;
  final List<Color> gradient;
  final double? width;
  final double height;
  final bool isLoading;
  const GradientButton ({
    required this.text,
    required this.onPressed,
    this.gradient = TColors.primaryGradient,
    this.width,
    this.height = 56,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradient,
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: gradient.first.withOpacity(0.3),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: ElevatedButton(onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: TColors.primary,
          foregroundColor: TColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)
          ),
          padding: EdgeInsets.zero,
        ),
        child: Center(
          child: isLoading ? SizedBox(
            height: 24,
            width: 24,
            child: CircularProgressIndicator(
              color: TColors.light,
              strokeWidth: 2,
            ),
          ) : Text(text,
            style: TextStyle(
              color: TColors.light,
              fontSize: TSizes.fontSizeMd,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }
}