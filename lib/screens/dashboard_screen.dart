import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../core/constants/app_color.dart';
import '../../widgets/bottom_navbar.dart';
import '../../screens/activity_log_screen.dart';
import '../screens/notification_screen.dart';

class DashboardScreen extends StatefulWidget {
  final String petName;
  final String petAge;
  final String petBreed;

  const DashboardScreen({
    super.key,
    required this.petName,
    required this.petAge,
    required this.petBreed,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _alarmOn = true;
  bool _monitoringOn = true;
  bool _nearDoor = true; // true = Move!, false = Safe

  void _toggleMonitoring() {
    setState(() => _monitoringOn = !_monitoringOn);
  }

  // gaya teks pixel dan text body
  TextStyle _pixel(double size, Color color) =>
    GoogleFonts.pressStart2p(fontSize: size, color: color);
  TextStyle _body(double size, Color color) =>
    GoogleFonts.vt323(fontSize: size, color: color);
    
  void _onNavTap(int index) {
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ActivityLogScreen()),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.navy,
      bottomNavigationBar: BottomNavbar(currentIndex: 0, onTap: _onNavTap),
      body: Column(
        children: [
          _header(),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration:  BoxDecoration(
                color: AppColor.cream,
                borderRadius: BorderRadius.vertical(
                  top: Radius.elliptical(300, 50),
                ),
              ),
              child: ListView(
                padding: EdgeInsets.fromLTRB(20, 28, 20, 20),
                children: [
                  _monitoringPill(),
                  SizedBox(height: 20),
                  _pawDetectorCard(),
                  SizedBox(height: 14),
                  _alarmCard(),
                  SizedBox(height: 14),
                  _petCard(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // header
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

            Row(
              children: [
                Flexible(
                  child: Text(
                    'Welcome, ${widget.petName}',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColor.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(width: 6),
                Icon(
                  Icons.pets,
                  color: AppColor.white,
                  size: 18,
                ),
              ],
            ),

            SizedBox(height: 5),

            Text(
              "Let's monitor your pet today!",
              style: _body(15, AppColor.white),
            ),
          ],
        ),
      ),
    );
  }

  // pil monitoring active
  Widget _monitoringPill() {
    final color = _monitoringOn ? AppColor.navy : AppColor.grey;

    return Center(
      child: GestureDetector(
        onTap: _toggleMonitoring,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          decoration: BoxDecoration(
            color: AppColor.cream,
            borderRadius: BorderRadius.circular(45),
            border: Border.all(color: color, width: 1.5),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.circle,
                size: 8,
                color: color,
              ),
              SizedBox(width: 8),
              Text(
                _monitoringOn ? 'Monitoring Active' : 'Monitoring Off',
                style: _pixel(9, color),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // card paw detector
  Widget _pawDetectorCard() {
    final on = _monitoringOn;
    final near = _nearDoor;

    final Color dotColor = !on 
      ? AppColor.grey 
      : (near ? AppColor.red : AppColor.green);
    final String statusText = !on ? 'Standby' : (near ? 'Move!' : 'Safe');
    final String message = !on
        ? 'Monitoring is turned off'
        : (near
            ? 'Movement detected at the door!'
            : 'No movement near the door');

    return GestureDetector(
      onTap: () => setState(() => _nearDoor = !_nearDoor),
      child: _card(
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  Icons.pets,
                  size: 70,
                  color: on ? AppColor.navy : AppColor.grey,
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Paw Detector',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: on ? AppColor.navy : AppColor.grey,
                        ),
                      ),
                      SizedBox(height: 13),
                      Row(
                        children: [
                          Icon(
                            Icons.circle,
                            size: 10,
                            color: dotColor,
                          ),
                          SizedBox(width: 6),
                          Text(
                            statusText,
                            style: _pixel(10, AppColor.navy),
                          ),
                        ],
                      ),
                      SizedBox(height: 6),
                      Text(message, style: _body(13, AppColor.grey)),
                      Text(
                        on ? 'Last detected: 8:30 AM' : 'Tap the pill to turn on',
                        style: _body(13, AppColor.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            _infoRow(Icons.directions_run, 'Motion:',
                !on ? '-' : (near ? 'Detected' : 'None')),
            const SizedBox(height: 4),
            _infoRow(Icons.straighten, 'Range:', !on ? '-' : (near ? '~0 m' : '-')),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColor.navy),
        SizedBox(width: 6),
        Text(label, style: _body(15, AppColor.navy)),
        SizedBox(width: 6),
        Text(value, style: _body(15, AppColor.navy)),
      ],
    );
  }

  // card status alarm
  Widget _alarmCard() {
    final on = _monitoringOn;

    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.volume_up, size: 18, color: AppColor.navy),
              SizedBox(width: 8),
              Expanded(
                child: Text('Status Alarm:', style: _body(18, AppColor.navy)),
              ),
              Switch(
                value: _alarmOn,
                onChanged: on ? (v) => setState(() => _alarmOn = v) : null,
              ),
            ],
          ),
          SizedBox(height: 6),
          Center(
            child: Text(
              !on
                  ? 'Monitoring off'
                  : !_alarmOn
                      ? 'Alarm off'
                      : (_nearDoor ? 'BEEPING! : 8:45 AM' : 'Alarm ready'),
              style: _body(15, AppColor.navy),
            ),
          ),
        ],
      ),
    );
  }

  // card info pet dengan StreamBuilder realtime dari Firebase
  Widget _petCard() {
    return StreamBuilder(
      stream: FirebaseDatabase.instance.ref("pet_profile").onValue,
      builder: (context, snapshot) {
        String name = widget.petName;
        String age = widget.petAge;
        String breed = widget.petBreed;

        if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
          var data = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
          name = data['name'] ?? widget.petName;
          age = data['age'] ?? widget.petAge;
          breed = data['breed'] ?? widget.petBreed;
        }

        return _card(
          child: Row(
            children: [
              Icon(Icons.pets, size: 40, color: AppColor.navy),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColor.navy,
                      ),
                    ),
                    Text(
                      '$age years, $breed',
                      style: _body(14, AppColor.navy),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // pembungkus card putih
  Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: child,
    );
  }
}