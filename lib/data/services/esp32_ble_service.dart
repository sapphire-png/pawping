import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

enum WifiSetupResult { success, wifiFailed, deviceNotFound, bluetoothOff, error }

class Esp32BleService {
  static const String deviceName = 'PawPing-Setup';
  static final Guid _serviceUuid = Guid('5a7e0001-9c4b-4f6e-8a1d-3b2c1d0e0001');
  static final Guid _rxUuid = Guid('5a7e0002-9c4b-4f6e-8a1d-3b2c1d0e0001');
  static final Guid _txUuid = Guid('5a7e0003-9c4b-4f6e-8a1d-3b2c1d0e0001');

  Future<WifiSetupResult> sendWifi({
    required String ssid,
    required String password,
    void Function(String message)? onProgress,
  }) async {
    BluetoothDevice? device;
    try {
      if (!await _ensureBluetoothOn()) return WifiSetupResult.bluetoothOff;

      onProgress?.call('Mencari ESP32...');
      device = await _scan();
      if (device == null) return WifiSetupResult.deviceNotFound;

      onProgress?.call('Menyambung ke ESP32...');
      await device.connect(
        license: License.nonprofit,
        timeout: const Duration(seconds: 15),
      );

      final services = await device.discoverServices();
      final service = services.firstWhere((s) => s.uuid == _serviceUuid);
      final rx = service.characteristics.firstWhere((c) => c.uuid == _rxUuid);
      final tx = service.characteristics.firstWhere((c) => c.uuid == _txUuid);

      // status dari ESP32: WAIT / OK / FAIL
      final hasil = Completer<String>();
      final sub = tx.onValueReceived.listen((value) {
        final s = utf8.decode(value, allowMalformed: true);
        if (s == 'WAIT') onProgress?.call('ESP32 menyambung ke WiFi...');
        if ((s == 'OK' || s == 'FAIL') && !hasil.isCompleted) {
          hasil.complete(s);
        }
      });
      device.cancelWhenDisconnected(sub);
      await tx.setNotifyValue(true);

      onProgress?.call('Mengirim nama & password WiFi...');
      final data = utf8.encode('${jsonEncode({'s': ssid, 'p': password})}\n');
      for (var i = 0; i < data.length; i += 20) {
        final end = (i + 20 < data.length) ? i + 20 : data.length;
        await rx.write(data.sublist(i, end)); // potongan 20 byte, aman di semua MTU
      }

      final status = await hasil.future.timeout(const Duration(seconds: 40));
      return status == 'OK'
          ? WifiSetupResult.success
          : WifiSetupResult.wifiFailed;
    } catch (e) {
      debugPrint('BLE ERROR: $e');
      return WifiSetupResult.error;
    } finally {
      try {
        await FlutterBluePlus.stopScan();
      } catch (_) {}
      try {
        await device?.disconnect();
      } catch (_) {}
    }
  }

  Future<bool> _ensureBluetoothOn() async {
    try {
      await FlutterBluePlus.adapterState
          .where((s) => s == BluetoothAdapterState.on)
          .first
          .timeout(const Duration(seconds: 2));
      return true;
    } on TimeoutException {
      try {
        await FlutterBluePlus.turnOn(); // hanya Android
      } catch (_) {}
      try {
        await FlutterBluePlus.adapterState
            .where((s) => s == BluetoothAdapterState.on)
            .first
            .timeout(const Duration(seconds: 10));
        return true;
      } on TimeoutException {
        return false;
      }
    }
  }

  Future<BluetoothDevice?> _scan() async {
    final found = Completer<BluetoothDevice>();
    final sub = FlutterBluePlus.onScanResults.listen((results) {
      for (final r in results) {
        final name = r.advertisementData.advName.isNotEmpty
            ? r.advertisementData.advName
            : r.device.platformName;
        if (name == deviceName && !found.isCompleted) {
          found.complete(r.device);
        }
      }
    });
    try {
      await FlutterBluePlus.startScan(
        withNames: [deviceName],
        webOptionalServices: [_serviceUuid],
        timeout: const Duration(seconds: 15),
      );
      return await found.future.timeout(const Duration(seconds: 15));
    } on TimeoutException {
      return null;
    } finally {
      await sub.cancel();
      try {
        await FlutterBluePlus.stopScan();
      } catch (_) {}
    }
  }
}
