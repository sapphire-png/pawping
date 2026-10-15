import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pawping/core/constants/app_color.dart';
import 'package:pawping/data/models/notification_model.dart';

class NotificationCard extends StatelessWidget {
  final NotificationModel item;

  const NotificationCard({super.key, required this.item});

  // indikator kiri: dot berwarna, atau ikon speaker untuk alarm
  Widget _leading() {
    switch (item.type) {
      case NotificationType.alarmOn:
      case NotificationType.alarmOff:
        return const Icon(Icons.volume_up, size: 16, color: AppColor.navy);
      case NotificationType.movement:
        return _dot(AppColor.red);
      case NotificationType.motion:
        return _dot(AppColor.yellow);
      case NotificationType.ignored:
        return _dot(AppColor.grey);
      case NotificationType.safe:
        return _dot(AppColor.green);
    }
  }

  Widget _dot(Color color) => Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _leading(),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  item.title,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                    color: AppColor.navy,
                  ),
                ),
              ),
              Text(
                item.timeLabel,
                style: GoogleFonts.poppins(
                  fontSize: 9,
                  letterSpacing: 1,
                  color: AppColor.navy,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Divider(height: 1, thickness: 1, color: AppColor.grey),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              item.message,
              style: GoogleFonts.poppins(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                letterSpacing: 1,
                height: 1.4,
                color: AppColor.navy.withValues(alpha: 0.75),
              ),
            ),
          ),
        ],
      ),
    );
  }
}