import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLarge;
  final IconData? icon;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isLarge = false,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isLarge ? double.infinity : null,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(
            horizontal: isLarge ? 0 : 24,
            vertical: 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 5,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon),
              const SizedBox(width: 8),
            ],
            Text(
              text,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}