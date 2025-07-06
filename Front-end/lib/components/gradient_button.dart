import 'package:flutter/material.dart';
import 'package:cdp_app/color_palette.dart';

class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const GradientButton(
      {super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30), // Rounded corners
          gradient: LinearGradient(
            colors: [
              primaryLight, // Light Sand Yellow
              primaryBase, // Sand Yellow
            ], // Applying gradient with sand yellow theme
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: textPrimary, // Deep Blue-Gray for good contrast
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
