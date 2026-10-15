import 'package:flutter/material.dart';
import '../constants/app_color.dart';

class AppTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.white,

      // Skema warna utama 
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColor.navy,
        primary: AppColor.navy,
        secondary: AppColor.cream,
      ),

      // Toggle Status Alarm di Dashboard
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.all(Colors.white),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? AppColor.navy
              : Colors.grey.shade400,
        ),
      ),
    );
  }
}