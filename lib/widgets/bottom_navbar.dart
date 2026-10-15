import 'package:flutter/material.dart';
import '../../core/constants/app_color.dart';

class BottomNavbar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavbar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  Widget _item(IconData icon, String label, int index) {
    final selected = currentIndex == index;
    final color = selected ? AppColor.white : AppColor.cream;

    return InkWell(
      onTap: () => onTap(index),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 20),
            SizedBox(height: 4),
            Text(label, style: TextStyle(color: color, fontSize: 11)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.navy,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _item(Icons.home, 'Home', 0),
              _item(Icons.list_alt, 'Activity', 1),
            ],
          ),
        ),
      ),
    );
  }
}