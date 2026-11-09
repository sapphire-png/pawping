import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_color.dart';
import '../../data/services/esp32_ble_service.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class WifiSetupScreen extends StatefulWidget {
  const WifiSetupScreen({super.key});

  @override
  State<WifiSetupScreen> createState() => _WifiSetupScreenState();
}

class _WifiSetupScreenState extends State<WifiSetupScreen> {
  final _ssidC = TextEditingController();
  final _passC = TextEditingController();
  final _service = Esp32BleService();

  bool _busy = false;
  bool _hidePass = true;
  String _status = '';
  Color _statusColor = AppColor.navy;

  @override
  void dispose() {
    _ssidC.dispose();
    _passC.dispose();
    super.dispose();
  }

  void _setStatus(String text, {Color color = AppColor.navy}) {
    if (!mounted) return;
    setState(() {
      _status = text;
      _statusColor = color;
    });
  }

  Future<void> _kirim() async {
    if (_busy) return;
    final ssid = _ssidC.text.trim();
    final pass = _passC.text; // password tidak di-trim
    if (ssid.isEmpty) {
      _setStatus('Nama WiFi wajib diisi', color: AppColor.red);
      return;
    }

    setState(() => _busy = true);
    final result = await _service.sendWifi(
      ssid: ssid,
      password: pass,
      onProgress: (m) => _setStatus(m),
    );
    if (!mounted) return;
    setState(() => _busy = false);

    switch (result) {
      case WifiSetupResult.success:
        _setStatus('Berhasil! ESP32 sudah tersambung ke WiFi.',
            color: AppColor.green);
        await Future.delayed(const Duration(seconds: 2));
        if (mounted) Navigator.pop(context);
        break;
      case WifiSetupResult.wifiFailed:
        _setStatus(
            'ESP32 gagal tersambung. Cek nama & password WiFi (harus 2.4 GHz).',
            color: AppColor.red);
        break;
      case WifiSetupResult.deviceNotFound:
        _setStatus(
            'ESP32 tidak ditemukan. Pastikan ESP32 menyala, dekat HP, dan belum '
            'tersambung WiFi (mode setup aktif otomatis).',
            color: AppColor.red);
        break;
      case WifiSetupResult.bluetoothOff:
        _setStatus('Bluetooth belum menyala.', color: AppColor.red);
        break;
      case WifiSetupResult.error:
        _setStatus('Terjadi kesalahan. Coba lagi.', color: AppColor.red);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.cream,
      appBar: AppBar(
        backgroundColor: AppColor.navy,
        foregroundColor: AppColor.white,
        title: Text(
          'WIFI SETUP',
          style: GoogleFonts.pressStart2p(fontSize: 12, color: AppColor.white),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hubungkan ESP32 ke WiFi',
                style: GoogleFonts.vt323(fontSize: 26, color: AppColor.navy),
              ),
              const SizedBox(height: 6),
              Text(
                'Nyalakan Bluetooth dan dekatkan HP ke ESP32. Gunakan WiFi 2.4 GHz.',
                style: GoogleFonts.vt323(fontSize: 18, color: AppColor.navy),
              ),
              const SizedBox(height: 24),
              CustomTextField(
                label: 'WIFI NAME (SSID)',
                hint: 'Nama WiFi / hotspot',
                controller: _ssidC,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'PASSWORD',
                hint: 'Password WiFi',
                controller: _passC,
                obscureText: _hidePass,
                suffixIcon: IconButton(
                  icon: Icon(
                    _hidePass ? Icons.visibility : Icons.visibility_off,
                    size: 18,
                  ),
                  onPressed: () => setState(() => _hidePass = !_hidePass),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: CustomButton(
                  text: _busy ? 'Memproses...' : 'Kirim ke ESP32',
                  icon: Icons.bluetooth,
                  onPressed: _kirim,
                ),
              ),
              const SizedBox(height: 20),
              if (_busy) const Center(child: CircularProgressIndicator()),
              if (_status.isNotEmpty)
                Center(
                  child: Text(
                    _status,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.vt323(fontSize: 18, color: _statusColor),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
