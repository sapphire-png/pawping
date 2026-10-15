import 'package:flutter/material.dart';
import '../../core/constants/app_color.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool filled;
  final IconData? icon;
  final double width;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.filled = true,
    this.icon,
    this.width = 220,
  });

  @override
  Widget build(BuildContext context) {
    final fg = filled ? AppColor.white : AppColor.navy;
    
    return SizedBox(
      width: width,
      height: 40,
      child: ElevatedButton(
        onPressed: onPressed, 
        style: ElevatedButton.styleFrom(
          backgroundColor: filled ? AppColor.navy : AppColor.lightBlue,
          foregroundColor: fg,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16),
              const SizedBox(width: 8),
            ],
            Text(text, style: TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}