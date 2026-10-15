import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_color.dart';
import '../../data/models/activity_log_model.dart';
import '../../widgets/bottom_navbar.dart';
import '../../screens/notification_screen.dart';

class ActivityLogScreen extends StatefulWidget {
  const ActivityLogScreen({super.key});

  @override
  State<ActivityLogScreen> createState() => _ActivityLogScreenState();
}

class _ActivityLogScreenState extends State<ActivityLogScreen> {
  final _filters = ['All', 'Safe', 'Alarm', 'Ignore'];
  int _selected = 0;

  // masih data dummy
  final _logs = const [
    ActivityLog(
      date: 'Saturday, 05 Sep 2026',
      time: '12.00 PM',
      type: ActivityType.alarm,
      message: 'Pet detected triggered.',
      motion: 'Detected',
      range: '40 meter',
    ),
    ActivityLog(
      date: 'Saturday, 05 Sep 2026',
      time: '6.00 PM',
      type: ActivityType.safe,
      message: 'Area clear',
      motion: 'Clear',
      range: '120 meter',
    ),
    ActivityLog(
      date: 'Thursday, 04 Sep 2026',
      time: '11.00 PM',
      type: ActivityType.ignored,
      message: 'Pet detected triggered.',
      motion: 'Detected',
      range: '20 meter',
    ),
  ];

  TextStyle _pixel(double size, Color color) =>
      GoogleFonts.pressStart2p(fontSize: size, color: color);
  TextStyle _body(double size, Color color) =>
      GoogleFonts.vt323(fontSize: size, color: color);

  List<ActivityLog> get _filtered {
    switch(_selected) {
      case 1:
        return _logs.where((l) => l.type == ActivityType.safe).toList();
      case 2:
        return _logs.where((l) => l.type == ActivityType.alarm).toList();
      case 3:
        return _logs.where((l) => l.type == ActivityType.ignored).toList();
      default:
        return _logs;
    }
  }

  Color _dotColor(ActivityType t) {
    switch (t) {
      case ActivityType.alarm:
        return AppColor.red;
      case ActivityType.safe:
        return AppColor.green;
      case ActivityType.ignored:
        return AppColor.grey;
    }
  }

  String _label(ActivityType t) {
    switch (t) {
      case ActivityType.alarm:
        return 'Alarm';
      case ActivityType.safe:
        return 'Safe';
      case ActivityType.ignored:
        return 'Ignored';
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = _filtered;

    return Scaffold(
      backgroundColor: AppColor.navy,
      bottomNavigationBar: BottomNavbar(
        currentIndex: 1, 
        onTap: (i) {
          if (i == 0) Navigator.pop(context); // dia nanti balik ke dashboard
        },
      ),
      body: Column(
        children: [
          _header(),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColor.cream,
                borderRadius: BorderRadius.vertical(
                  top: Radius.elliptical(300, 50),
                ),
              ),
              child: ListView(
                padding: EdgeInsets.fromLTRB(20, 28, 20, 20),
                children: [
                  _filterChips(),
                  SizedBox(height: 18),
                  if (items.isEmpty)
                    Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: Center(
                        child: Text(
                          'No activity yet',
                          style: _body(16, AppColor.grey),
                        ),
                      ),
                    ),
                  ...items.map(_logCard),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  //  header
  Widget _header() {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 12, 20, 22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(
                  'assets/images/pet-pawping-logo2.png',
                  width: 30,
                  filterQuality: FilterQuality.none,
                ),
                SizedBox(width: 8),
                Text(
                  'PAWPING',
                  style: _pixel(10, AppColor.white),
                ),
                Spacer(),
                // tap lonceng -> buka halaman Notifications
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const NotificationScreen(),
                    ),
                  ),
                  child: Icon(
                    Icons.notifications,
                    color: AppColor.white,
                    size: 18,
                  ),
                ),
              ],
            ),

            SizedBox(height: 22),

            Text(
              'Activity Log',
              style: TextStyle(
                color: AppColor.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 4),

            Text(
              'Track your pet movement and alarms!',
              style: _body(15, AppColor.white),
            ),
          ],
        ),
      ),
    );
  }

  // chip filter: All / Safe / Alarm / Ignore
  Widget _filterChips() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: List.generate(_filters.length, (i) {
        final active = _selected == i;
        return GestureDetector(
          onTap: () => setState(() => _selected = i),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 150),
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              color: active ? AppColor.navy : AppColor.cream,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColor.navy, width: 1.5),
            ),
            child: Text(
              _filters[i],
              style: _pixel(9, active ? AppColor.white : AppColor.navy),
            ),
          ),
        );
      }),
    );
  }

  // satu kartu log
  Widget _logCard(ActivityLog log) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(log.date, style: _pixel(7, AppColor.navy)),
              ),
              Text(log.time, style: _pixel(7, AppColor.navy)),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.circle, size: 10, color: _dotColor(log.type)),
              SizedBox(width: 6),
              Text(
                _label(log.type),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColor.navy,
                ),
              ),
            ],
          ),
          SizedBox(height: 2),
          Text(log.message, style: _body(15, AppColor.navy)),
          Divider(height: 20),
          Row(
            children: [
              _info(Icons.directions_run, 'Motion:', log.motion),
              Spacer(),
              _info(Icons.straighten, 'Range:', log.range),
            ],
          ),
        ],
      ),
    );
  }

  Widget _info(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 13, color: AppColor.navy),
        SizedBox(width: 4),
        Text('$label $value', style: _body(14, AppColor.navy)),
      ],
    );
  }
}