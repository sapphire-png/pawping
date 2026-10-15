enum NotificationType { movement, motion, alarmOn, alarmOff, ignored, safe }

class NotificationModel {
  final String id;
  final NotificationType type;
  final String title;
  final String message;
  final DateTime createdAt;

  const NotificationModel({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.createdAt,
  });

  // nanti dipakai waktu ambil data dari Supabase
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'].toString(),
      type: NotificationType.values.firstWhere(
        (t) => t.name == json['type'],
        orElse: () => NotificationType.movement,
      ),
      title: json['title'] as String,
      message: json['message'] as String,
      createdAt: DateTime.parse(json['created_at'] as String).toLocal(),
    );
  }

  bool get isToday {
    final now = DateTime.now();
    return createdAt.year == now.year &&
        createdAt.month == now.month &&
        createdAt.day == now.day;
  }

  // label waktu: Just Now, 5m ago, 5h ago, Yesterday, 2d ago, Weeks ago
  String get timeLabel {
    final diff = DateTime.now().difference(createdAt);
    if (diff.inMinutes < 1) return 'Just Now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24 && isToday) return '${diff.inHours}h ago';
    if (diff.inDays <= 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return 'Weeks ago';
  }

  // data dummy sesuai desain Figma
  static List<NotificationModel> get dummy {
    final now = DateTime.now();
    return [
      NotificationModel(
        id: '1',
        type: NotificationType.movement,
        title: 'Movement Detected',
        message: 'Your pet detected near the front door\nin distance 20 centimeter.',
        createdAt: now,
      ),
      NotificationModel(
        id: '2',
        type: NotificationType.motion,
        title: 'Motion Alert',
        message: 'Alert ignored for 10 seconds. Buzzer alarm\nautomatically activated!',
        createdAt: now.subtract(const Duration(minutes: 5)),
      ),
      NotificationModel(
        id: '3',
        type: NotificationType.alarmOn,
        title: 'Alarm Activated',
        message: 'Buzzer turned on manually from Dashboard.',
        createdAt: now.subtract(const Duration(minutes: 30)),
      ),
      NotificationModel(
        id: '4',
        type: NotificationType.alarmOff,
        title: 'Alarm Deactivated',
        message: 'Buzzer has been turned off.',
        createdAt: now.subtract(const Duration(days: 1)),
      ),
      NotificationModel(
        id: '5',
        type: NotificationType.ignored,
        title: 'Alert Ignored',
        message: 'Movement notification at 08:30 AM\nwas ignored.',
        createdAt: now.subtract(const Duration(days: 2)),
      ),
      NotificationModel(
        id: '6',
        type: NotificationType.safe,
        title: 'Area Safe',
        message: 'No movement detected near the door.\nArea is clear.',
        createdAt: now.subtract(const Duration(days: 14)),
      ),
    ];
  }
}