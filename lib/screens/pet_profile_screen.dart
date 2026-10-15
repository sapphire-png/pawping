import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../core/constants/app_color.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../screens/dashboard_screen.dart';

class PetProfileScreen extends StatefulWidget {
  const PetProfileScreen({super.key});

  @override
  State<PetProfileScreen> createState() => _PetProfileScreenState();
}

class _PetProfileScreenState extends State<PetProfileScreen> {
  final _nameC = TextEditingController();
  final _ageC = TextEditingController();
  final _breedC = TextEditingController();

  @override
  void dispose() {
    _nameC.dispose();
    _ageC.dispose();
    _breedC.dispose();
    super.dispose();
  }

  void _createProfile() async {
    // validasi sederhana: nama wajib diisi
    if (_nameC.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama hewan wajib diisi')),
      );
      return;
    }

    try {
      // Simpan data ke Firebase Realtime Database
      DatabaseReference ref = FirebaseDatabase.instance.ref("pet_profile");
      await ref.set({
        "name": _nameC.text.trim(),
        "age": _ageC.text.trim().isEmpty ? '-' : _ageC.text.trim(),
        "breed": _breedC.text.trim().isEmpty ? '-' : _breedC.text.trim(),
      });

      // Pindah ke DashboardScreen setelah berhasil disimpan
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => DashboardScreen(
              petName: _nameC.text.trim(),
              petAge: _ageC.text.trim().isEmpty ? '-' : _ageC.text.trim(),
              petBreed: _breedC.text.trim().isEmpty ? '-' : _breedC.text.trim(),
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan ke database: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // buat header yg melengkung
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(top: 70, bottom: 50),
              decoration: BoxDecoration(
                color: AppColor.navy,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.elliptical(400, 60),
                  bottomRight: Radius.elliptical(400, 60),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    'PET PROFILE',
                    style: TextStyle(
                      color: AppColor.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),

                  SizedBox(height: 5),

                  Text(
                    'Create your pet profile!',
                    style: TextStyle(
                      color: AppColor.white,
                      fontSize: 20,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            // buat card form
            Container(
              margin: EdgeInsets.all(24),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColor.cream,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  CustomTextField(
                    label: 'Pet Name', 
                    hint: 'add your pet name', 
                    controller: _nameC,
                  ),

                  SizedBox(height: 15),

                  CustomTextField(
                    label: 'Pet Age', 
                    hint: 'add your pet age', 
                    controller: _ageC,
                    keyboardType: TextInputType.number,
                  ),

                  SizedBox(height: 15),

                  CustomTextField(
                    label: 'Pet Breed', 
                    hint: 'e.g Golden Retriever', 
                    controller: _breedC
                  ),
                ],
              ),
            ),

            SizedBox(height: 25),

            // button
            CustomButton(
              text: 'Create Pet Profile', 
              icon: Icons.pets,
              onPressed: _createProfile
            ),

            SizedBox(height: 200),

            // footer
            Text(
              '© 2026 PawPing. All rights reserved.',
              style: TextStyle(
                fontSize: 11,
                letterSpacing: 1,
                color: AppColor.grey,
              ),
            ),

            SizedBox(height: 35),
          ],
        ),
      ),
    );
  }
}