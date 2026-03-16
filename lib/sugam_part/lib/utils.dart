import 'package:flutter_blue_plus/flutter_blue_plus.dart';

/// BLE UUIDs and Constants for SmartHelmet
/// These MUST match exactly with your ESP32 code
class BLEConstants {
  static final Guid serviceUUID = Guid("0000abcd-0000-1000-8000-00805f9b34fb");
  static final Guid notifyCharUUID = Guid(
    "00001234-0000-1000-8000-00805f9b34fb",
  );
  static final Guid writeCharUUID = Guid(
    "00005678-0000-1000-8000-00805f9b34fb",
  );
}

/// Optional utility functions
String bytesToString(List<int> bytes) => String.fromCharCodes(bytes);
List<int> stringToBytes(String str) => str.codeUnits;
