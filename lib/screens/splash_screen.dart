import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../screens/pet_profile_screen.dart';
import '../../core/constants/app_color.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.navy,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          Navigator.pushReplacement(
            context, 
            MaterialPageRoute(builder: (_) => const PetProfileScreen()),
          );
        },
        child: SizedBox.expand(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // logo pawping
              Image.asset(
                'assets/images/pet-pawping-logo.png',
                width: 350,
                filterQuality: FilterQuality.none,
              ),

              SizedBox(height: 20),

              Text(
                'PAWPING',
                style: GoogleFonts.pressStart2p(
                  fontSize: 30,
                  color: AppColor.white,
                  letterSpacing: 3,
                ),
              ),

              SizedBox(height: 5),

              Text(
                'Click to get started',
                style: GoogleFonts.vt323(
                  fontSize: 30,
                  color: AppColor.whiteSoft,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}