import 'package:flutter/material.dart';

class TCategoryBar extends StatelessWidget {
  final List<Widget> buttons;
  const TCategoryBar({super.key, required this.buttons});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFE0E0E0), // Màu xám nhạt
            width: 1,
          ),
        ),
        color: Colors.white,
      ),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: buttons,
      ),
    );
  }
}

class CategoryButton extends StatelessWidget {
  final String label;
  const CategoryButton({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(width: 2),
        const Icon(Icons.keyboard_arrow_down_rounded, size: 20),
      ],
    );
  }
}
