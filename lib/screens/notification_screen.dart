import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:pawping/core/constants/app_color.dart';
import 'package:pawping/data/models/notification_model.dart';
import 'package:pawping/widgets/bottom_navbar.dart';
import 'package:pawping/widgets/notification_card.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  TextStyle _pixel(double size, Color color) =>
      GoogleFonts.pressStart2p(fontSize: size, color: color);

  void _onNavTap(int index) {
    if (index == 0) {
      Navigator.pop(context); // balik ke Dashboard
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Activity Log belum dibuat')),
      );
    }
  }

  void _markAllRead() {
    // Fungsi untuk menandai semua dibaca di Firebase (bisa dikembangkan nanti)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Semua notifikasi ditandai sudah dibaca')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.navy,
      bottomNavigationBar: BottomNavbar(currentIndex: -1, onTap: _onNavTap),
      body: Column(
        children: [
          _header(),
          Expanded(
            child: Container(
              width: double.infinity,
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(
                color: AppColor.cream,
                borderRadius: BorderRadius.vertical(
                  top: Radius.elliptical(300, 50),
                ),
              ),
              child: StreamBuilder(
                stream: FirebaseDatabase.instance.ref("sensor/log").onValue,
                builder: (context, snapshot) {
                  List<NotificationModel> items = [];

                  if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
                    final rawData = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
                    
                    rawData.forEach((key, value) {
                      final mapVal = Map<String, dynamic>.from(value);
                      
                      final int gerak = mapVal['gerak'] ?? 0;
                      final dynamic jarak = mapVal['jarak'] ?? 0.0;

                      String title = gerak == 1 ? 'Movement Detected' : 'Area Safe';
                      String message = gerak == 1 
                          ? 'Gerakan terdeteksi di dekat pintu dengan jarak $jarak cm.' 
                          : 'Tidak ada gerakan di dekat pintu. Area aman.';
                      
                      NotificationType type = gerak == 1 ? NotificationType.movement : NotificationType.safe;

                      var rawWaktu = mapVal['waktu'];
                      DateTime createdAt = DateTime.now();
                      
                      if (rawWaktu != null) {
                        int millis = rawWaktu is int ? rawWaktu : int.tryParse(rawWaktu.toString()) ?? 0;
                        if (millis > 0) {
                          createdAt = DateTime.fromMillisecondsSinceEpoch(millis);
                        }
                      }

                      final jsonMap = {
                        'id': key.toString(),
                        'type': type.name,
                        'title': title,
                        'message': message,
                        'created_at': createdAt.toIso8601String(),
                      };

                      items.add(NotificationModel.fromJson(jsonMap));
                    });
                  }

                  if (items.isEmpty) {
                    return Center(
                      child: Text(
                        'Belum ada data sensor',
                        style: GoogleFonts.lato(fontSize: 14, color: AppColor.grey),
                      ),
                    );
                  }

                  items.sort((b, a) => a.createdAt.compareTo(b.createdAt));

                  final today = items.where((n) => n.isToday).toList();
                  final earlier = items.where((n) => !n.isToday).toList();

                  return ListView(
                    padding: const EdgeInsets.fromLTRB(20, 32, 20, 24),
                    children: [
                      if (today.isNotEmpty) ..._section('Today', today),
                      if (earlier.isNotEmpty) ..._section('Earlier', earlier),
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

  List<Widget> _section(String label, List<NotificationModel> list) {
    return [
      Padding(
        padding: const EdgeInsets.fromLTRB(4, 0, 0, 12),
        child: Text(
          label,
          style: GoogleFonts.lato(
            fontSize: 15,
            letterSpacing: 1,
            color: AppColor.navy.withValues(alpha: 0.8),
          ),
        ),
      ),
      for (final n in list) ...[
        NotificationCard(item: n),
        const SizedBox(height: 14),
      ],
      const SizedBox(height: 12),
    ];
  }

  Widget _header() {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 22),
        child: Column(
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
                const Icon(Icons.notifications, color: AppColor.white, size: 18),
              ],
            ),
            const SizedBox(height: 22),
            Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_back,
                      color: AppColor.white, size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    'Notifications',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                      color: AppColor.white,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: _markAllRead,
                  child: const Icon(Icons.done_all,
                      color: AppColor.white, size: 22),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}