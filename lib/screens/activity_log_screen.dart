import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
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

  TextStyle _pixel(double size, Color color) =>
      GoogleFonts.pressStart2p(fontSize: size, color: color);
  TextStyle _body(double size, Color color) =>
      GoogleFonts.vt323(fontSize: size, color: color);

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
    return Scaffold(
      backgroundColor: AppColor.navy,
      bottomNavigationBar: BottomNavbar(
        currentIndex: 1, 
        onTap: (i) {
          if (i == 0) Navigator.pop(context); // balik ke dashboard
        },
      ),
      body: Column(
        children: [
          _header(),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppColor.cream,
                borderRadius: BorderRadius.vertical(
                  top: Radius.elliptical(300, 50),
                ),
              ),
              child: StreamBuilder(
                // Mengambil data dari node 'sensor/log'[cite: 10]
                stream: FirebaseDatabase.instance.ref("sensor/log").onValue,
                builder: (context, snapshot) {
                  List<ActivityLog> logs = [];
                  List<Map<String, dynamic>> rawList = [];

                  if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
                    final rawData = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;

                    // Masukkan semua data ke dalam list sementara
                    rawData.forEach((key, value) {
                      final mapVal = Map<String, dynamic>.from(value);
                      rawList.add(mapVal);
                    });

                    // Urutkan berdasarkan milidetik waktu (terbaru/terbesar di atas)
                    rawList.sort((a, b) => (b['waktu'] ?? 0).compareTo(a['waktu'] ?? 0));

                    for (var mapVal in rawList) {
                      final int gerak = mapVal['gerak'] ?? 0;
                      final dynamic jarak = mapVal['jarak'] ?? 0.0;
                      
                      // Konversi waktu milidetik dari database[cite: 10]
                      var rawWaktu = mapVal['waktu'];
                      DateTime dateTime = DateTime.now();
                      if (rawWaktu != null) {
                        int millis = rawWaktu is int ? rawWaktu : int.tryParse(rawWaktu.toString()) ?? 0;
                        if (millis > 0) {
                          dateTime = DateTime.fromMillisecondsSinceEpoch(millis);
                        }
                      }

                      // Format tanggal dan jam menggunakan package intl[cite: 10]
                      final dateFormatter = DateFormat('EEEE, dd MMM yyyy');
                      final timeFormatter = DateFormat('hh:mm a');

                      String formattedDate = dateFormatter.format(dateTime);
                      String formattedTime = timeFormatter.format(dateTime);

                      // Tentukan tipe aktivitas berdasarkan data sensor[cite: 10]
                      ActivityType type = gerak == 1 ? ActivityType.alarm : ActivityType.safe;
                      String message = gerak == 1 ? 'Pet detected triggered.' : 'Area clear';
                      String motionStr = gerak == 1 ? 'Detected' : 'Clear';
                      String rangeStr = '$jarak cm';

                      logs.add(ActivityLog(
                        date: formattedDate,
                        time: formattedTime,
                        type: type,
                        message: message,
                        motion: motionStr,
                        range: rangeStr,
                      ));
                    }
                  }

                  // Filter berdasarkan pilihan chip[cite: 10]
                  List<ActivityLog> filtered;
                  switch (_selected) {
                    case 1:
                      filtered = logs.where((l) => l.type == ActivityType.safe).toList();
                      break;
                    case 2:
                      filtered = logs.where((l) => l.type == ActivityType.alarm).toList();
                      break;
                    case 3:
                      filtered = logs.where((l) => l.type == ActivityType.ignored).toList();
                      break;
                    default:
                      filtered = logs;
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // filter: tetap diam, tidak ikut scroll
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
                        child: _filterChips(),
                      ),
                      const SizedBox(height: 18),
                      // hanya daftar kartu yang scroll
                      Expanded(
                        child: ListView(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                          children: [
                            if (filtered.isEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 40),
                                child: Center(
                                  child: Text(
                                    'No activity yet',
                                    style: _body(16, AppColor.grey),
                                  ),
                                ),
                              ),
                            ...filtered.map(_logCard),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Header[cite: 10]
  Widget _header() {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 22),
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
                const SizedBox(width: 8),
                Text('PAWPING', style: _pixel(10, AppColor.white)),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const NotificationScreen(),
                    ),
                  ),
                  child: const Icon(
                    Icons.notifications,
                    color: AppColor.white,
                    size: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),
            Text(
              'Activity Log',
              style: TextStyle(
                color: AppColor.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Track your pet movement and alarms!',
              style: _body(15, AppColor.white),
            ),
          ],
        ),
      ),
    );
  }

  // Chip filter[cite: 10]
   // Chip filter
  Widget _filterChips() {
    return SizedBox(
      width: double.infinity,
      child: Wrap(
        alignment: WrapAlignment.center, // chip rata tengah
        spacing: 8,
        runSpacing: 8,
        children: List.generate(_filters.length, (i) {
          final active = _selected == i;
          return GestureDetector(
            onTap: () => setState(() => _selected = i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
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
      ),
    );
  }

  // Satu kartu log[cite: 10]
  Widget _logCard(ActivityLog log) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
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
              Expanded(
                child: Text(log.date, style: _pixel(7, AppColor.navy)),
              ),
              Text(log.time, style: _pixel(7, AppColor.navy)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.circle, size: 10, color: _dotColor(log.type)),
              const SizedBox(width: 6),
              Text(
                _label(log.type),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColor.navy,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(log.message, style: _body(15, AppColor.navy)),
          const Divider(height: 20),
          Row(
            children: [
              _info(Icons.directions_run, 'Motion:', log.motion),
              const Spacer(),
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
        const SizedBox(width: 4),
        Text('$label $value', style: _body(14, AppColor.navy)),
      ],
    );
  }
}