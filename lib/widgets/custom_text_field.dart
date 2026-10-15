import 'package:flutter/material.dart';
import '../../core/constants/app_color.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final TextInputType keyboardType;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.keyboardType = TextInputType.text,
  });

  OutlineInputBorder _border(Color color) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: color),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            letterSpacing: 1,
            color: AppColor.navy,
          ),
        ),

        SizedBox(height: 6),

        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              fontSize: 12,
              letterSpacing: 1,
              color: AppColor.grey,
            ),
            filled: true,
            fillColor: AppColor.fieldFill,
            contentPadding: 
              const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
            enabledBorder: _border(AppColor.fieldBorder),
            focusedBorder: _border(AppColor.navy),
          ),
        ),
      ],
    );
  }
}