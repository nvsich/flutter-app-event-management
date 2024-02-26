import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.buttonColor,
    this.labalColor,
  });

  final String label;
  final VoidCallback onPressed;
  final Color? buttonColor;
  final Color? labalColor;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor ?? Colors.pink,
        foregroundColor: labalColor ?? Colors.white,
        minimumSize: const Size(double.maxFinite, 50),
      ),
      onPressed: onPressed,
      child: Text(label),
    );
  }
}
