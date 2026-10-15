enum ActivityType { alarm, safe, ignored }

class ActivityLog {
  final String date;
  final String time;
  final ActivityType type;
  final String message;
  final String motion;
  final String range;

  const ActivityLog({
    required this.date,
    required this.time,
    required this.type,
    required this.message,
    required this.motion,
    required this.range,
  });
}