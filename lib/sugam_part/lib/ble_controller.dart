// // ignore_for_file: deprecated_member_use, empty_catches, use_rethrow_when_possible

// import 'dart:async';
// import 'dart:typed_data';
// import 'package:flutter_blue_plus/flutter_blue_plus.dart';
// import 'package:pasa/core/services/crash_service.dart';
// import 'package:pasa/core/top_level/di.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:logger/logger.dart';
// import 'utils.dart';

// var logger = Logger();

// /// FINAL BLE Controller with MPU6050 Support
// /// Supports both 14-byte (old) and 26-byte (with MPU) formats
// class BleController {
//   bool _bleReady = false;
//   List<int>? _pendingCommand;

//   // ==================== SENSOR DATA ====================
//   // Basic sensors
//   int alcohol = 0; // 0-100%
//   bool helmetWorn = false; // true/false
//   bool crashDetected = false; // true/false

//   // MPU6050 IMU data
//   double accX = 0.0; // Accelerometer X (g)
//   double accY = 0.0; // Accelerometer Y (g)
//   double accZ = 0.0; // Accelerometer Z (g)
//   double gyroX = 0.0; // Gyroscope X (deg/s)
//   double gyroY = 0.0; // Gyroscope Y (deg/s)
//   double gyroZ = 0.0; // Gyroscope Z (deg/s)

//   // GPS coordinates
//   double latitude = 0.0;
//   double longitude = 0.0;

//   // GPS tracking
//   bool isUsingMobileGPS = false;
//   DateTime? lastHelmetGPSUpdate;
//   static const Duration helmetGPSTimeout = Duration(seconds: 10);

//   // ==================== BLE STATE ====================
//   BluetoothDevice? connectedDevice;
//   BluetoothCharacteristic? notifyChar;
//   BluetoothCharacteristic? writeChar;

//   // ==================== CALLBACKS ====================
//   Function(String data)? onDataReceived;
//   Function(String status)? onStatusChange;

//   // ==================== CONFIGURATION ====================
//   static const String targetDeviceName = "SmartHelmet";

//   // ==================== PRIVATE STATE ====================
//   StreamSubscription<List<ScanResult>>? _scanSubscription;
//   StreamSubscription<BluetoothConnectionState>? _connectionSubscription;
//   StreamSubscription<Position>? _mobileGPSSubscription;
//   StreamSubscription<List<int>>? _notifySubscription;

//   Timer? _scanTimer;
//   Timer? _reconnectTimer;
//   Timer? _gpsCheckTimer;

//   bool _isConnecting = false;
//   bool _isScanning = false;
//   bool _manualDisconnect = false;
//   bool _useMobileGPS = true;
//   bool _isDisposed = false;

//   // ==================== PERMISSIONS ====================

//   Future<bool> _checkPermissions() async {
//     try {
//       Map<Permission, PermissionStatus> statuses = await [
//         Permission.location,
//         Permission.bluetoothScan,
//         Permission.bluetoothConnect,
//       ].request();

//       bool allGranted = statuses.values.every((status) => status.isGranted);

//       if (!allGranted) {
//         logger.e("Permissions denied");
//         return false;
//       }

//       return true;
//     } catch (e) {
//       logger.e("Permission error: $e");
//       return false;
//     }
//   }

//   // ==================== MOBILE GPS ====================

//   Future<void> startMobileGPS() async {
//     if (_isDisposed) return;

//     try {
//       bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//       if (!serviceEnabled) {
//         logger.w("Location services disabled");
//         onStatusChange?.call("Enable location services");
//         return;
//       }

//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//       }

//       if (permission == LocationPermission.denied ||
//           permission == LocationPermission.deniedForever) {
//         logger.e("Location permission denied");
//         return;
//       }

//       await _mobileGPSSubscription?.cancel();

//       // Get initial position
//       try {
//         Position position = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high,
//           timeLimit: const Duration(seconds: 5),
//         );
//         _updateMobileGPS(position);
//       } catch (e) {
//         logger.w("Initial GPS failed: $e");
//       }

//       // Start continuous tracking
//       _mobileGPSSubscription =
//           Geolocator.getPositionStream(
//             locationSettings: const LocationSettings(
//               accuracy: LocationAccuracy.high,
//               distanceFilter: 10,
//             ),
//           ).listen(
//             _updateMobileGPS,
//             onError: (error) => logger.e("Mobile GPS error: $error"),
//             cancelOnError: false,
//           );

//       logger.i("Mobile GPS started");
//     } catch (e) {
//       logger.e("Mobile GPS failed: $e");
//     }
//   }

//   void _updateMobileGPS(Position position) {
//     if (_isDisposed) return;

//     if (lastHelmetGPSUpdate == null ||
//         DateTime.now().difference(lastHelmetGPSUpdate!) > helmetGPSTimeout) {
//       latitude = position.latitude;
//       longitude = position.longitude;
//       isUsingMobileGPS = true;
//       logger.d("Mobile GPS: ($latitude, $longitude)");
//     }
//   }

//   bool _lastCrash = false;

//   void handleBleUpdate(bool crashDetected) {
//     if (crashDetected && !_lastCrash) {
//       _lastCrash = true;
//       getIt<CrashService>().onCrashDetected();
//     }

//     if (!crashDetected) {
//       _lastCrash = false;
//     }
//   }

//   Future<void> stopMobileGPS() async {
//     await _mobileGPSSubscription?.cancel();
//     _mobileGPSSubscription = null;
//     isUsingMobileGPS = false;
//     logger.i("Mobile GPS stopped");
//   }

//   void setMobileGPSEnabled(bool enabled) {
//     _useMobileGPS = enabled;
//     if (enabled) {
//       startMobileGPS();
//     } else {
//       stopMobileGPS();
//     }
//     logger.i("Mobile GPS ${enabled ? 'enabled' : 'disabled'}");
//   }

//   // ==================== SCANNING ====================

//   Future<void> startAutoScan() async {
//     if (_isDisposed || _isScanning || _isConnecting) return;

//     _reconnectTimer?.cancel();

//     // Check if already connected
//     if (connectedDevice != null) {
//       try {
//         var state = await connectedDevice!.connectionState.first.timeout(
//           const Duration(seconds: 2),
//         );
//         if (state == BluetoothConnectionState.connected) {
//           logger.i("Already connected");
//           onStatusChange?.call("Connected");
//           return;
//         }
//       } catch (e) {
//         connectedDevice = null;
//       }
//     }

//     // Check Bluetooth
//     try {
//       bool isBtOn = await FlutterBluePlus.isOn;
//       if (!isBtOn) {
//         logger.w("Bluetooth off");
//         onStatusChange?.call("Bluetooth is off");
//         return;
//       }
//     } catch (e) {
//       logger.e("Bluetooth check error: $e");
//       return;
//     }

//     if (!await _checkPermissions()) {
//       onStatusChange?.call("Permissions denied");
//       return;
//     }

//     if (_useMobileGPS) startMobileGPS();

//     await stopScan();
//     await Future.delayed(const Duration(milliseconds: 500));

//     _isScanning = true;
//     _manualDisconnect = false;
//     onStatusChange?.call("Scanning...");
//     logger.i("🔍 Scan started");

//     try {
//       await FlutterBluePlus.startScan(
//         timeout: const Duration(seconds: 15),
//         androidUsesFineLocation: true,
//       );

//       _scanSubscription = FlutterBluePlus.scanResults.listen((results) async {
//         if (_isDisposed || !_isScanning) return;

//         for (ScanResult r in results) {
//           if (r.device.platformName == targetDeviceName) {
//             logger.i("✓ Found SmartHelmet!");
//             onStatusChange?.call("Found SmartHelmet!");

//             await stopScan();
//             await Future.delayed(const Duration(milliseconds: 300));

//             if (!_isDisposed && !_isConnecting) {
//               await connectToDevice(r.device);
//             }
//             break;
//           }
//         }
//       });

//       _scanTimer = Timer(const Duration(seconds: 16), () async {
//         if (_isDisposed) return;
//         if (connectedDevice == null && _isScanning) {
//           await stopScan();
//           onStatusChange?.call("Device not found");
//           logger.w("Scan timeout");

//           if (!_manualDisconnect) {
//             _reconnectTimer = Timer(const Duration(seconds: 5), () {
//               if (!_isDisposed &&
//                   !_manualDisconnect &&
//                   connectedDevice == null) {
//                 startAutoScan();
//               }
//             });
//           }
//         }
//       });
//     } catch (e) {
//       logger.e("Scan error: $e");
//       await stopScan();
//     }
//   }

//   Future<void> stopScan() async {
//     if (!_isScanning) return;

//     _scanTimer?.cancel();
//     await _scanSubscription?.cancel();

//     try {
//       bool scanning = await FlutterBluePlus.isScanning.first.timeout(
//         const Duration(seconds: 2),
//         onTimeout: () => false,
//       );
//       if (scanning) await FlutterBluePlus.stopScan();
//     } catch (e) {}

//     _isScanning = false;
//     logger.i("Scan stopped");
//   }

//   Future<bool> cancelSOS() async {
//     return sendCommand([0x01]); // 0x01 is the cancel SOS command
//   }

//   // ==================== CONNECTION ====================

//   Future<void> connectToDevice(BluetoothDevice device) async {
//     if (_isDisposed || _isConnecting) return;

//     _isConnecting = true;
//     logger.i("🔗 Connecting to ${device.platformName}");

//     try {
//       await _connectionSubscription?.cancel();
//       await _notifySubscription?.cancel();

//       // Disconnect previous if different
//       if (connectedDevice != null &&
//           connectedDevice!.remoteId != device.remoteId) {
//         try {
//           await connectedDevice!.disconnect().timeout(
//             const Duration(seconds: 3),
//           );
//           await Future.delayed(const Duration(milliseconds: 500));
//         } catch (e) {}
//       }

//       connectedDevice = null;
//       notifyChar = null;
//       writeChar = null;

//       onStatusChange?.call("Connecting...");

//       // Setup connection listener
//       _connectionSubscription = device.connectionState.listen((state) {
//         if (_isDisposed) return;

//         logger.i("State: $state");

//         if (state == BluetoothConnectionState.disconnected) {
//           _bleReady = false;

//           logger.w("Disconnected");
//           onStatusChange?.call("Disconnected");

//           _gpsCheckTimer?.cancel();

//           bool shouldReconnect = connectedDevice != null && !_manualDisconnect;

//           connectedDevice = null;
//           notifyChar = null;
//           writeChar = null;
//           _isConnecting = false;

//           if (shouldReconnect && !_isDisposed) {
//             _reconnectTimer = Timer(const Duration(seconds: 3), () {
//               if (!_isDisposed &&
//                   !_manualDisconnect &&
//                   connectedDevice == null) {
//                 startAutoScan();
//               }
//             });
//           }
//         }
//       });

//       // Connect
//       await device.connect(
//         autoConnect: false,
//         license: License.commercial,
//         timeout: const Duration(seconds: 30),
//       );

//       await Future.delayed(const Duration(milliseconds: 1500));

//       var state = await device.connectionState.first.timeout(
//         const Duration(seconds: 5),
//         onTimeout: () => BluetoothConnectionState.disconnected,
//       );

//       if (state != BluetoothConnectionState.connected) {
//         throw Exception("Connection failed");
//       }

//       connectedDevice = device;
//       _manualDisconnect = false;
//       logger.i("✓ Connected!");
//       onStatusChange?.call("Discovering services...");

//       // Request MTU
//       try {
//         int mtu = await device.requestMtu(512);
//         logger.i("MTU: $mtu");
//       } catch (e) {
//         logger.w("MTU request failed: $e");
//       }

//       await Future.delayed(const Duration(milliseconds: 500));

//       // Discover services
//       await _discoverServices(device);

//       // Start GPS monitoring
//       _startGPSMonitoring();

//       _isConnecting = false;
//     } catch (e) {
//       logger.e("Connection failed: $e");
//       onStatusChange?.call("Connection failed");

//       await _connectionSubscription?.cancel();
//       connectedDevice = null;
//       notifyChar = null;
//       writeChar = null;
//       _isConnecting = false;

//       if (!_manualDisconnect && !_isDisposed) {
//         _reconnectTimer = Timer(const Duration(seconds: 5), () {
//           if (!_isDisposed && !_manualDisconnect && connectedDevice == null) {
//             startAutoScan();
//           }
//         });
//       }
//     }
//   }

//   // ==================== SERVICE DISCOVERY ====================

//   Future<void> _discoverServices(BluetoothDevice device) async {
//     if (_isDisposed) return;

//     try {
//       logger.i("Discovering services...");

//       final services = await device.discoverServices().timeout(
//         const Duration(seconds: 20),
//       );

//       if (_isDisposed) return;

//       bool found = false;
//       for (final service in services) {
//         if (service.uuid == BLEConstants.serviceUUID) {
//           logger.i("✓ Service found!");
//           found = true;

//           for (final char in service.characteristics) {
//             // Notify characteristic
//             if (char.uuid == BLEConstants.notifyCharUUID) {
//               await _notifySubscription?.cancel();

//               await char.setNotifyValue(true);
//               await Future.delayed(const Duration(milliseconds: 300));

//               _notifySubscription = char.lastValueStream.listen(
//                 (value) {
//                   if (_isDisposed) return;
//                   _handleData(value);
//                 },
//                 onError: (error) => logger.e("Notify error: $error"),
//                 cancelOnError: false,
//               );

//               notifyChar = char;
//               logger.i("✓ Notify ready");
//             }

//             // Write characteristic
//             if (char.uuid == BLEConstants.writeCharUUID) {
//               writeChar = char;
//               logger.i("✓ Write ready");
//             }
//           }
//           break;
//         }
//       }

//       if (!found) {
//         throw Exception("Service not found");
//       }

//       if (notifyChar == null || writeChar == null) {
//         throw Exception("Characteristics not found");
//       }

//       _bleReady = true;
//       logger.i("✓ BLE READY (notify + write)");

//       // Send pending command with a small delay to ensure BLE is fully ready
//       if (_pendingCommand != null) {
//         final cmd = _pendingCommand!;
//         _pendingCommand = null; // Clear it first

//         Future.delayed(Duration(milliseconds: 100), () async {
//           logger.i("Sending queued command: $cmd");
//           await writeChar!.write(cmd, withoutResponse: false);
//           logger.i("✓ Command sent: $cmd");
//         });
//       }

//       onStatusChange?.call("Connected & Ready");
//     } catch (e) {
//       logger.e("Service discovery failed: $e");
//       throw e;
//     }
//   }

//   // ==================== DATA HANDLING ====================

//   /// Handle incoming data - supports both 14-byte and 26-byte formats
//   void _handleData(List<int> value) {
//     if (_isDisposed) return;
//     if (!_bleReady) {
//       logger.w("Notify received before BLE ready — ignored");
//       return;
//     }
//     try {
//       if (value.length < 14) {
//         logger.w("Incomplete data: ${value.length} bytes");
//         return;
//       }

//       // Basic sensors (bytes 0-5) - SAME FOR BOTH FORMATS
//       alcohol = value[0];
//       helmetWorn = value[1] == 1;
//       crashDetected = value[4] == 1;

//       // Check format and parse accordingly
//       if (value.length >= 26) {
//         // NEW 26-byte format with MPU6050
//         _parseMPUData(value);
//         _parseGPSData26(value);
//         logger.d("📦 26-byte format detected");
//       } else if (value.length >= 14) {
//         // OLD 14-byte format without MPU6050
//         _parseGPSData14(value);
//         // Reset MPU data
//         accX = accY = accZ = 0.0;
//         gyroX = gyroY = gyroZ = 0.0;
//         logger.d("📦 14-byte format detected");
//       }

//       _logSensorData();
//       _notifyDataReceived();
//       handleBleUpdate(crashDetected);
//     } catch (e) {
//       logger.e("Data handling error: $e");
//     }
//   }

//   /// Parse MPU6050 data (bytes 6-17) for 26-byte format
//   void _parseMPUData(List<int> value) {
//     try {
//       var axBytes = Uint8List.fromList(value.sublist(6, 8));
//       var ayBytes = Uint8List.fromList(value.sublist(8, 10));
//       var azBytes = Uint8List.fromList(value.sublist(10, 12));
//       var gxBytes = Uint8List.fromList(value.sublist(12, 14));
//       var gyBytes = Uint8List.fromList(value.sublist(14, 16));
//       var gzBytes = Uint8List.fromList(value.sublist(16, 18));

//       int ax = ByteData.sublistView(axBytes).getInt16(0, Endian.little);
//       int ay = ByteData.sublistView(ayBytes).getInt16(0, Endian.little);
//       int az = ByteData.sublistView(azBytes).getInt16(0, Endian.little);
//       int gx = ByteData.sublistView(gxBytes).getInt16(0, Endian.little);
//       int gy = ByteData.sublistView(gyBytes).getInt16(0, Endian.little);
//       int gz = ByteData.sublistView(gzBytes).getInt16(0, Endian.little);

//       // Convert from scaled values
//       accX = ax / 1000.0;
//       accY = ay / 1000.0;
//       accZ = az / 1000.0;
//       gyroX = gx / 100.0;
//       gyroY = gy / 100.0;
//       gyroZ = gz / 100.0;
//     } catch (e) {
//       logger.w("MPU parse error: $e");
//     }
//   }

//   /// Parse GPS data (bytes 18-25) for 26-byte format
//   void _parseGPSData26(List<int> value) {
//     try {
//       var latBytes = Uint8List.fromList(value.sublist(18, 22));
//       var lngBytes = Uint8List.fromList(value.sublist(22, 26));

//       double helmetLat = ByteData.sublistView(
//         latBytes,
//       ).getFloat32(0, Endian.little);
//       double helmetLng = ByteData.sublistView(
//         lngBytes,
//       ).getFloat32(0, Endian.little);

//       if (helmetLat != 0.0 &&
//           helmetLng != 0.0 &&
//           helmetLat.abs() <= 90 &&
//           helmetLng.abs() <= 180) {
//         latitude = helmetLat;
//         longitude = helmetLng;
//         lastHelmetGPSUpdate = DateTime.now();

//         if (isUsingMobileGPS) {
//           logger.i("✓ Helmet GPS restored");
//           isUsingMobileGPS = false;
//         }
//       }
//     } catch (e) {
//       logger.w("GPS parse error: $e");
//     }
//   }

//   /// Parse GPS data (bytes 6-13) for 14-byte format
//   void _parseGPSData14(List<int> value) {
//     try {
//       var latBytes = Uint8List.fromList(value.sublist(6, 10));
//       var lngBytes = Uint8List.fromList(value.sublist(10, 14));

//       double helmetLat = ByteData.sublistView(
//         latBytes,
//       ).getFloat32(0, Endian.little);
//       double helmetLng = ByteData.sublistView(
//         lngBytes,
//       ).getFloat32(0, Endian.little);

//       if (helmetLat != 0.0 &&
//           helmetLng != 0.0 &&
//           helmetLat.abs() <= 90 &&
//           helmetLng.abs() <= 180) {
//         latitude = helmetLat;
//         longitude = helmetLng;
//         lastHelmetGPSUpdate = DateTime.now();

//         if (isUsingMobileGPS) {
//           logger.i("✓ Helmet GPS restored");
//           isUsingMobileGPS = false;
//         }
//       }
//     } catch (e) {
//       logger.w("GPS parse error: $e");
//     }
//   }

//   void _logSensorData() {
//     String helmetStatus = helmetWorn ? "Worn ✅" : "Not Worn ❌";
//     String crashStatus = crashDetected ? "CRASH ⚠️" : "Normal";
//     String gpsSource = isUsingMobileGPS ? "(Mobile)" : "(Helmet)";

//     logger.d(
//       "Alcohol:$alcohol% | $helmetStatus |  "
//       "$crashStatus | GPS$gpsSource:($latitude,$longitude) | "
//       "Acc:($accX,$accY,$accZ) | Gyro:($gyroX,$gyroY,$gyroZ)",
//     );
//   }

//   void _notifyDataReceived() {
//     String helmetStatus = helmetWorn ? "Helmet Worn ✅" : "Not Worn ❌";
//     String crashStatus = crashDetected ? "CRASH ⚠️" : "Normal";
//     String gpsSource = isUsingMobileGPS ? "(Mobile)" : "(Helmet)";

//     onDataReceived?.call(
//       "Alcohol: $alcohol%\n$helmetStatus\n"
//       "\n$crashStatus\nGPS $gpsSource: $latitude, $longitude",
//     );
//   }

//   // ==================== GPS MONITORING ====================

//   void _startGPSMonitoring() {
//     if (_isDisposed) return;

//     _gpsCheckTimer?.cancel();
//     _gpsCheckTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
//       if (_isDisposed) {
//         timer.cancel();
//         return;
//       }

//       if (lastHelmetGPSUpdate != null) {
//         Duration timeSince = DateTime.now().difference(lastHelmetGPSUpdate!);

//         if (timeSince > helmetGPSTimeout &&
//             !isUsingMobileGPS &&
//             _useMobileGPS) {
//           logger.w("Helmet GPS timeout, switching to mobile");
//           if (_mobileGPSSubscription == null) startMobileGPS();
//         }
//       } else if (_useMobileGPS && _mobileGPSSubscription == null) {
//         startMobileGPS();
//       }
//     });
//   }

//   // ==================== SEND COMMAND ====================

//   // Future<bool> sendCommand(List<int> command) async {
//   //   if (_isDisposed) return false;

//   //   if (!_bleReady || writeChar == null) {
//   //     logger.w("BLE not ready — command queued: $command");
//   //     _pendingCommand = command;
//   //     return false;
//   //   }

//   //   try {
//   //     await writeChar!
//   //         .write(command, withoutResponse: true)
//   //         .timeout(const Duration(seconds: 5));

//   //     logger.i("✓ Command sent: $command");
//   //     return true;
//   //   } catch (e) {
//   //     logger.e("Command failed: $e");
//   //     return false;
//   //   }
//   // }
//   Future<bool> sendCommand(List<int> command) async {
//     if (_isDisposed) return false;

//     if (!_bleReady || writeChar == null) {
//       logger.w("BLE not ready — command queued: $command");

//       // Only queue if not already queued (prevents duplicates)
//       _pendingCommand ??= command;
//       return false;
//     }

//     try {
//       await writeChar!
//           .write(command, withoutResponse: false)
//           .timeout(const Duration(seconds: 5));

//       logger.i("✓ Command sent: $command");
//       _pendingCommand = null; // Clear pending command after success
//       return true;
//     } catch (e) {
//       logger.e("Command failed: $e");
//       return false;
//     }
//   }
//   // ==================== DISCONNECT ====================

//   Future<void> disconnect() async {
//     try {
//       logger.i("Disconnecting...");

//       _manualDisconnect = true;
//       _isConnecting = false;
//       _isScanning = false;

//       _reconnectTimer?.cancel();
//       _gpsCheckTimer?.cancel();
//       _scanTimer?.cancel();

//       await _scanSubscription?.cancel();
//       await _connectionSubscription?.cancel();
//       await _notifySubscription?.cancel();

//       try {
//         bool scanning = await FlutterBluePlus.isScanning.first.timeout(
//           const Duration(seconds: 2),
//           onTimeout: () => false,
//         );
//         if (scanning) await FlutterBluePlus.stopScan();
//       } catch (e) {}

//       if (connectedDevice != null) {
//         try {
//           await connectedDevice!.disconnect().timeout(
//             const Duration(seconds: 5),
//           );
//         } catch (e) {}
//       }

//       connectedDevice = null;
//       writeChar = null;
//       notifyChar = null;

//       onStatusChange?.call("Disconnected");
//       logger.i("✓ Disconnected");
//     } catch (e) {
//       logger.e("Disconnect error: $e");
//     }
//   }

//   // ==================== DISPOSE ====================

//   Future<void> dispose() async {
//     _isDisposed = true;
//     _manualDisconnect = true;

//     _scanTimer?.cancel();
//     _reconnectTimer?.cancel();
//     _gpsCheckTimer?.cancel();

//     await _scanSubscription?.cancel();
//     await _connectionSubscription?.cancel();
//     await _notifySubscription?.cancel();

//     await stopMobileGPS();
//     await disconnect();

//     logger.i("✓ Disposed");
//   }

//   // ==================== GETTERS ====================

//   bool get isConnected => connectedDevice != null;
//   bool get isScanning => _isScanning;
//   bool get isConnecting => _isConnecting;

//   String get connectionStatus {
//     if (_isDisposed) return "Disposed";
//     if (_isConnecting) return "Connecting...";
//     if (connectedDevice != null) return "Connected";
//     if (_isScanning) return "Scanning...";
//     if (_manualDisconnect) return "Disconnected";
//     return "Ready";
//   }
// }
import 'dart:async';
import 'dart:typed_data';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:pasa/core/services/crash_service.dart';
import 'package:pasa/core/top_level/di.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';
import 'utils.dart';

var logger = Logger();

/// FINAL BLE Controller with MPU6050 Support
/// Supports both 14-byte (old) and 26-byte (with MPU) formats
class BleController {
  bool _bleReady = false;
  // ==================== RIDER PROFILE ====================
  String _name = '';
  int _age = 0;
  int _bloodGroup = 0;
  String _medicalInfo = '';
  List<String> _phones = [];

  bool _profileSent = false;
  List<int>? _pendingCommand;

  // ==================== SENSOR DATA ====================
  // Basic sensors
  int alcohol = 0; // 0-100%
  bool helmetWorn = false; // true/false
  bool crashDetected = false; // true/false

  // MPU6050 IMU data
  double accX = 0.0; // Accelerometer X (g)
  double accY = 0.0; // Accelerometer Y (g)
  double accZ = 0.0; // Accelerometer Z (g)
  double gyroX = 0.0; // Gyroscope X (deg/s)
  double gyroY = 0.0; // Gyroscope Y (deg/s)
  double gyroZ = 0.0; // Gyroscope Z (deg/s)

  // GPS coordinates
  double latitude = 0.0;
  double longitude = 0.0;

  // GPS tracking
  bool isUsingMobileGPS = false;
  DateTime? lastHelmetGPSUpdate;
  static const Duration helmetGPSTimeout = Duration(seconds: 10);

  // ==================== BLE STATE ====================
  BluetoothDevice? connectedDevice;
  BluetoothCharacteristic? notifyChar;
  BluetoothCharacteristic? writeChar;

  // ==================== CALLBACKS ====================
  Function(String data)? onDataReceived;
  Function(String status)? onStatusChange;

  // ==================== CONFIGURATION ====================
  static const String targetDeviceName = "SmartHelmet";

  // ==================== PRIVATE STATE ====================
  StreamSubscription<List<ScanResult>>? _scanSubscription;
  StreamSubscription<BluetoothConnectionState>? _connectionSubscription;
  StreamSubscription<Position>? _mobileGPSSubscription;
  StreamSubscription<List<int>>? _notifySubscription;

  Timer? _scanTimer;
  Timer? _reconnectTimer;
  Timer? _gpsCheckTimer;

  bool _isConnecting = false;
  bool _isScanning = false;
  bool _manualDisconnect = false;
  bool _useMobileGPS = true;
  bool _isDisposed = false;
  Future<void> setUserProfile({
    required String name,
    required int age,
    required int bloodGroup,
    required String medicalInfo,
  }) async {
    _name = name.trim();
    _age = age;
    _bloodGroup = bloodGroup;
    _medicalInfo = medicalInfo.trim();
    _profileSent = false;

    logger.i("User profile set");
    await _trySendProfileIfReady();
  }

  Future<void> setEmergencyPhones(List<String> phones) async {
    _phones = phones
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .take(3)
        .toList();

    _profileSent = false;

    logger.i("Emergency phones set: $_phones");
    await _trySendProfileIfReady();
  }

  bool get isProfileComplete {
    return _name.isNotEmpty && _age > 0;
  }

  Future<void> _trySendProfileIfReady() async {
    if (_isDisposed) return;
    if (_profileSent) return;

    if (!isProfileComplete) {
      logger.w("Profile incomplete, not sending yet");
      return;
    }

    if (!_bleReady || writeChar == null) {
      logger.w("BLE not ready, profile will be sent later");
      return;
    }

    final success = await sendRiderProfile(
      name: _name,
      age: _age,
      bloodGroup: _bloodGroup,
      medicalInfo: _medicalInfo,
      phones: _phones,
    );

    if (success) {
      _profileSent = true;
      logger.i("Stored profile sent successfully");
    }
  }

  String get riderName => _name;
  int get riderAge => _age;
  int get riderBloodGroup => _bloodGroup;
  String get riderMedicalInfo => _medicalInfo;
  List<String> get riderPhones => List.unmodifiable(_phones);
  // ==================== PERMISSIONS ====================
  Future<bool> _checkPermissions() async {
    try {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.location,
        Permission.bluetoothScan,
        Permission.bluetoothConnect,
      ].request();

      bool allGranted = statuses.values.every((status) => status.isGranted);

      if (!allGranted) {
        logger.e("Permissions denied");
        return false;
      }

      return true;
    } catch (e) {
      logger.e("Permission error: $e");
      return false;
    }
  }

  // ==================== MOBILE GPS ====================
  Future<void> startMobileGPS() async {
    if (_isDisposed) return;

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        logger.w("Location services disabled");
        onStatusChange?.call("Enable location services");
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        logger.e("Location permission denied");
        return;
      }

      await _mobileGPSSubscription?.cancel();

      // Get initial position
      try {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
          timeLimit: const Duration(seconds: 5),
        );
        _updateMobileGPS(position);
      } catch (e) {
        logger.w("Initial GPS failed: $e");
      }

      // Start continuous tracking
      _mobileGPSSubscription =
          Geolocator.getPositionStream(
            locationSettings: const LocationSettings(
              accuracy: LocationAccuracy.high,
              distanceFilter: 10,
            ),
          ).listen(
            _updateMobileGPS,
            onError: (error) => logger.e("Mobile GPS error: $error"),
            cancelOnError: false,
          );

      logger.i("Mobile GPS started");
    } catch (e) {
      logger.e("Mobile GPS failed: $e");
    }
  }

  void _updateMobileGPS(Position position) {
    if (_isDisposed) return;

    if (lastHelmetGPSUpdate == null ||
        DateTime.now().difference(lastHelmetGPSUpdate!) > helmetGPSTimeout) {
      latitude = position.latitude;
      longitude = position.longitude;
      isUsingMobileGPS = true;
      logger.d("Mobile GPS: ($latitude, $longitude)");
    }
  }

  bool _lastCrash = false;

  void handleBleUpdate(bool crashDetected) {
    if (crashDetected && !_lastCrash) {
      _lastCrash = true;
      getIt<CrashService>().onCrashDetected();
    }

    if (!crashDetected) {
      _lastCrash = false;
    }
  }

  Future<void> stopMobileGPS() async {
    await _mobileGPSSubscription?.cancel();
    _mobileGPSSubscription = null;
    isUsingMobileGPS = false;
    logger.i("Mobile GPS stopped");
  }

  void setMobileGPSEnabled(bool enabled) {
    _useMobileGPS = enabled;
    if (enabled) {
      startMobileGPS();
    } else {
      stopMobileGPS();
    }
    logger.i("Mobile GPS ${enabled ? 'enabled' : 'disabled'}");
  }

  // ==================== SCANNING ====================
  Future<void> startAutoScan() async {
    if (_isDisposed || _isScanning || _isConnecting) {
      return; // restore _isScanning check
    }

    _reconnectTimer?.cancel();

    // Check if already connected
    if (connectedDevice != null) {
      try {
        var state = await connectedDevice!.connectionState.first.timeout(
          const Duration(seconds: 2),
        );
        if (state == BluetoothConnectionState.connected) {
          logger.i("Already connected");
          onStatusChange?.call("Connected");
          return;
        }
      } catch (e) {
        connectedDevice = null;
      }
    }

    // Check Bluetooth
    try {
      bool isBtOn = await FlutterBluePlus.isOn;
      if (!isBtOn) {
        logger.w("Bluetooth off");
        onStatusChange?.call("Bluetooth is off");
        return;
      }
    } catch (e) {
      logger.e("Bluetooth check error: $e");
      return;
    }

    if (!await _checkPermissions()) {
      onStatusChange?.call("Permissions denied");
      return;
    }

    if (_useMobileGPS) startMobileGPS();

    await stopScan();
    await Future.delayed(const Duration(milliseconds: 500));

    _isScanning = true;
    _manualDisconnect = false;
    onStatusChange?.call("Scanning...");
    logger.i("🔍 Scan started");

    try {
      await FlutterBluePlus.startScan(
        timeout: const Duration(seconds: 15),
        androidUsesFineLocation: true,
      );

      _scanSubscription = FlutterBluePlus.scanResults.listen((results) async {
        if (_isDisposed || !_isScanning) return;
        for (ScanResult r in results) {
          if (r.device.platformName == targetDeviceName) {
            logger.i("✓ Found SmartHelmet!");
            onStatusChange?.call("Found SmartHelmet!");
            await stopScan();
            await Future.delayed(const Duration(milliseconds: 300));
            if (!_isDisposed && !_isConnecting) {
              await connectToDevice(r.device);
            }
            break;
          }
        }
      });

      _scanTimer = Timer(const Duration(seconds: 16), () async {
        if (_isDisposed) return;
        if (connectedDevice == null && _isScanning) {
          await stopScan();
          onStatusChange?.call("Device not found");
          logger.w("Scan timeout");
          if (!_manualDisconnect) {
            _reconnectTimer = Timer(const Duration(seconds: 5), () {
              if (!_isDisposed &&
                  !_manualDisconnect &&
                  connectedDevice == null) {
                startAutoScan();
              }
            });
          }
        }
      });
    } catch (e) {
      logger.e("Scan error: $e");
      await stopScan();
    }
  }

  Future<void> stopScan() async {
    if (!_isScanning) return;

    _scanTimer?.cancel();
    await _scanSubscription?.cancel();

    try {
      bool scanning = await FlutterBluePlus.isScanning.first.timeout(
        const Duration(seconds: 2),
        onTimeout: () => false,
      );
      if (scanning) await FlutterBluePlus.stopScan();
    // ignore: empty_catches
    } catch (e) {}

    _isScanning = false;
    logger.i("Scan stopped");
  }

  Future<bool> cancelSOS() async {
    return sendCommand([0x01]); // 0x01 is the cancel SOS command
  }

  // ==================== CONNECTION ====================
  Future<void> connectToDevice(BluetoothDevice device) async {
    if (_isDisposed || _isConnecting) return;

    _isConnecting = true;
    logger.i("🔗 Connecting to ${device.platformName}");

    try {
      await _connectionSubscription?.cancel();
      await _notifySubscription?.cancel();

      // Disconnect previous if different
      if (connectedDevice != null &&
          connectedDevice!.remoteId != device.remoteId) {
        try {
          await connectedDevice!.disconnect().timeout(
            const Duration(seconds: 3),
          );
          await Future.delayed(const Duration(milliseconds: 500));
        // ignore: empty_catches
        } catch (e) {}
      }

      connectedDevice = null;
      notifyChar = null;
      writeChar = null;

      onStatusChange?.call("Connecting...");

      // Setup connection listener
      _connectionSubscription = device.connectionState.listen((state) {
        if (_isDisposed) return;

        logger.i("State: $state");

        if (state == BluetoothConnectionState.disconnected) {
          _bleReady = false;

          logger.w("Disconnected");
          onStatusChange?.call("Disconnected");

          _gpsCheckTimer?.cancel();

          bool shouldReconnect = connectedDevice != null && !_manualDisconnect;

          connectedDevice = null;
          notifyChar = null;
          writeChar = null;
          _isConnecting = false;

          if (shouldReconnect && !_isDisposed) {
            _reconnectTimer = Timer(const Duration(seconds: 3), () {
              if (!_isDisposed &&
                  !_manualDisconnect &&
                  connectedDevice == null) {
                startAutoScan();
              }
            });
          }
        }
      });

      // Connect
      await device.connect(
        autoConnect: false,
        license: License.commercial,
        timeout: const Duration(seconds: 30),
      );

      await Future.delayed(const Duration(milliseconds: 1500));

      var state = await device.connectionState.first.timeout(
        const Duration(seconds: 5),
        onTimeout: () => BluetoothConnectionState.disconnected,
      );

      if (state != BluetoothConnectionState.connected) {
        throw Exception("Connection failed");
      }

      connectedDevice = device;
      _manualDisconnect = false;
      logger.i("✓ Connected!");
      onStatusChange?.call("Discovering services...");

      // Request MTU
      try {
        int mtu = await device.requestMtu(512);
        logger.i("MTU: $mtu");
      } catch (e) {
        logger.w("MTU request failed: $e");
      }

      await Future.delayed(const Duration(milliseconds: 500));

      // Discover services
      await _discoverServices(device);

      // Start GPS monitoring
      _startGPSMonitoring();
      Future.delayed(const Duration(milliseconds: 500), () {
        _trySendProfileIfReady();
      });
      _isConnecting = false;
    } catch (e) {
      logger.e("Connection failed: $e");
      onStatusChange?.call("Connection failed");

      await _connectionSubscription?.cancel();
      connectedDevice = null;
      notifyChar = null;
      writeChar = null;
      _isConnecting = false;

      if (!_manualDisconnect && !_isDisposed) {
        _reconnectTimer = Timer(const Duration(seconds: 5), () {
          if (!_isDisposed && !_manualDisconnect && connectedDevice == null) {
            startAutoScan();
          }
        });
      }
    }
  }

  // ==================== SERVICE DISCOVERY ====================
  Future<void> _discoverServices(BluetoothDevice device) async {
    if (_isDisposed) return;

    try {
      logger.i("Discovering services...");

      final services = await device.discoverServices().timeout(
        const Duration(seconds: 20),
      );

      if (_isDisposed) return;

      bool found = false;
      for (final service in services) {
        if (service.uuid == BLEConstants.serviceUUID) {
          logger.i("✓ Service found!");
          found = true;

          for (final char in service.characteristics) {
            // Notify characteristic
            if (char.uuid == BLEConstants.notifyCharUUID) {
              await _notifySubscription?.cancel();

              await char.setNotifyValue(true);
              await Future.delayed(const Duration(milliseconds: 300));

              _notifySubscription = char.lastValueStream.listen(
                (value) {
                  if (_isDisposed) return;
                  _handleData(value);
                },
                onError: (error) => logger.e("Notify error: $error"),
                cancelOnError: false,
              );

              notifyChar = char;
              logger.i("✓ Notify ready");
            }

            // Write characteristic
            if (char.uuid == BLEConstants.writeCharUUID) {
              writeChar = char;
              logger.i("✓ Write ready");
            }
          }
          break;
        }
      }

      if (!found) {
        throw Exception("Service not found");
      }

      if (notifyChar == null || writeChar == null) {
        throw Exception("Characteristics not found");
      }

      _bleReady = true;
      logger.i("✓ BLE READY (notify + write)");
      // if (_name.isNotEmpty && _age > 0 && _phones.isNotEmpty) {
      //   Future.delayed(const Duration(milliseconds: 300), () {
      //     _trySendProfileIfReady();
      //   });
      // }
      // Send pending command with a small delay to ensure BLE is fully ready
      if (_pendingCommand != null) {
        final cmd = _pendingCommand!;
        _pendingCommand = null; // Clear it first

        Future.delayed(Duration(milliseconds: 100), () async {
          logger.i("Sending queued command: $cmd");
          await writeChar!.write(cmd, withoutResponse: false);
          logger.i("✓ Command sent: $cmd");
        });
      }

      onStatusChange?.call("Connected & Ready");
    } catch (e) {
      logger.e("Service discovery failed: $e");
      rethrow;
    }
  }

  // ==================== DATA HANDLING ====================
  /// Handle incoming data - supports both 14-byte and 26-byte formats
  void _handleData(List<int> value) {
    if (_isDisposed) return;
    if (!_bleReady) {
      logger.w("Notify received before BLE ready — ignored");
      return;
    }
    try {
      if (value.length < 14) {
        logger.w("Incomplete data: ${value.length} bytes");
        return;
      }

      // Basic sensors (bytes 0-5) - SAME FOR BOTH FORMATS
      alcohol = value[0];
      helmetWorn = value[1] == 1;
      crashDetected = value[4] == 1;

      // Check format and parse accordingly
      if (value.length >= 26) {
        // NEW 26-byte format with MPU6050
        _parseMPUData(value);
        _parseGPSData26(value);
        logger.d("📦 26-byte format detected");
      } else if (value.length >= 14) {
        // OLD 14-byte format without MPU6050
        _parseGPSData14(value);
        // Reset MPU data
        accX = accY = accZ = 0.0;
        gyroX = gyroY = gyroZ = 0.0;
        logger.d("📦 14-byte format detected");
      }

      _logSensorData();
      _notifyDataReceived();
      handleBleUpdate(crashDetected);
    } catch (e) {
      logger.e("Data handling error: $e");
    }
  }

  /// Parse MPU6050 data (bytes 6-17) for 26-byte format
  void _parseMPUData(List<int> value) {
    try {
      var axBytes = Uint8List.fromList(value.sublist(6, 8));
      var ayBytes = Uint8List.fromList(value.sublist(8, 10));
      var azBytes = Uint8List.fromList(value.sublist(10, 12));
      var gxBytes = Uint8List.fromList(value.sublist(12, 14));
      var gyBytes = Uint8List.fromList(value.sublist(14, 16));
      var gzBytes = Uint8List.fromList(value.sublist(16, 18));

      int ax = ByteData.sublistView(axBytes).getInt16(0, Endian.little);
      int ay = ByteData.sublistView(ayBytes).getInt16(0, Endian.little);
      int az = ByteData.sublistView(azBytes).getInt16(0, Endian.little);
      int gx = ByteData.sublistView(gxBytes).getInt16(0, Endian.little);
      int gy = ByteData.sublistView(gyBytes).getInt16(0, Endian.little);
      int gz = ByteData.sublistView(gzBytes).getInt16(0, Endian.little);

      // Convert from scaled values
      accX = ax / 1000.0;
      accY = ay / 1000.0;
      accZ = az / 1000.0;
      gyroX = gx / 100.0;
      gyroY = gy / 100.0;
      gyroZ = gz / 100.0;
    } catch (e) {
      logger.w("MPU parse error: $e");
    }
  }

  /// Parse GPS data (bytes 18-25) for 26-byte format
  void _parseGPSData26(List<int> value) {
    try {
      var latBytes = Uint8List.fromList(value.sublist(18, 22));
      var lngBytes = Uint8List.fromList(value.sublist(22, 26));

      double helmetLat = ByteData.sublistView(
        latBytes,
      ).getFloat32(0, Endian.little);
      double helmetLng = ByteData.sublistView(
        lngBytes,
      ).getFloat32(0, Endian.little);

      if (helmetLat != 0.0 &&
          helmetLng != 0.0 &&
          helmetLat.abs() <= 90 &&
          helmetLng.abs() <= 180) {
        latitude = helmetLat;
        longitude = helmetLng;
        lastHelmetGPSUpdate = DateTime.now();

        if (isUsingMobileGPS) {
          logger.i("✓ Helmet GPS restored");
          isUsingMobileGPS = false;
        }
      }
    } catch (e) {
      logger.w("GPS parse error: $e");
    }
  }

  /// Parse GPS data (bytes 6-13) for 14-byte format
  void _parseGPSData14(List<int> value) {
    try {
      var latBytes = Uint8List.fromList(value.sublist(6, 10));
      var lngBytes = Uint8List.fromList(value.sublist(10, 14));

      double helmetLat = ByteData.sublistView(
        latBytes,
      ).getFloat32(0, Endian.little);
      double helmetLng = ByteData.sublistView(
        lngBytes,
      ).getFloat32(0, Endian.little);

      if (helmetLat != 0.0 &&
          helmetLng != 0.0 &&
          helmetLat.abs() <= 90 &&
          helmetLng.abs() <= 180) {
        latitude = helmetLat;
        longitude = helmetLng;
        lastHelmetGPSUpdate = DateTime.now();

        if (isUsingMobileGPS) {
          logger.i("✓ Helmet GPS restored");
          isUsingMobileGPS = false;
        }
      }
    } catch (e) {
      logger.w("GPS parse error: $e");
    }
  }

  void _logSensorData() {
    String helmetStatus = helmetWorn ? "Worn ✅" : "Not Worn ❌";
    String crashStatus = crashDetected ? "CRASH ⚠️" : "Normal";
    String gpsSource = isUsingMobileGPS ? "(Mobile)" : "(Helmet)";

    logger.d(
      "Alcohol:$alcohol% | $helmetStatus |  "
      "$crashStatus | GPS$gpsSource:($latitude,$longitude) | "
      "Acc:($accX,$accY,$accZ) | Gyro:($gyroX,$gyroY,$gyroZ)",
    );
  }

  void _notifyDataReceived() {
    String helmetStatus = helmetWorn ? "Helmet Worn ✅" : "Not Worn ❌";
    String crashStatus = crashDetected ? "CRASH ⚠️" : "Normal";
    String gpsSource = isUsingMobileGPS ? "(Mobile)" : "(Helmet)";

    onDataReceived?.call(
      "Alcohol: $alcohol%\n$helmetStatus\n"
      "\n$crashStatus\nGPS $gpsSource: $latitude, $longitude",
    );
  }

  // ==================== GPS MONITORING ====================
  void _startGPSMonitoring() {
    if (_isDisposed) return;

    _gpsCheckTimer?.cancel();
    _gpsCheckTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_isDisposed) {
        timer.cancel();
        return;
      }

      if (lastHelmetGPSUpdate != null) {
        Duration timeSince = DateTime.now().difference(lastHelmetGPSUpdate!);

        if (timeSince > helmetGPSTimeout &&
            !isUsingMobileGPS &&
            _useMobileGPS) {
          logger.w("Helmet GPS timeout, switching to mobile");
          if (_mobileGPSSubscription == null) startMobileGPS();
        }
      } else if (_useMobileGPS && _mobileGPSSubscription == null) {
        startMobileGPS();
      }
    });
  }

  // ==================== SEND COMMAND ====================
  Future<bool> sendCommand(List<int> command) async {
    if (_isDisposed) return false;

    if (!_bleReady || writeChar == null) {
      logger.w("BLE not ready — command queued: $command");

      // Only queue if not already queued (prevents duplicates)
      _pendingCommand ??= command;
      return false;
    }

    try {
      await writeChar!
          .write(command, withoutResponse: false)
          .timeout(const Duration(seconds: 5));

      logger.i("✓ Command sent: $command");
      _pendingCommand = null; // Clear pending command after success
      return true;
    } catch (e) {
      logger.e("Command failed: $e");
      return false;
    }
  }

  // ==================== NEW COMMANDS ====================
  Future<bool> startRide() async {
    return sendCommand([0x03]);
  }

  Future<bool> endRide() async {
    return sendCommand([0x04]);
  }

  Future<bool> sendRiderProfile({
    required String name,
    required int age,
    required int bloodGroup,
    required String medicalInfo,
    required List<String> phones,
  }) async {
    if (_isDisposed) return false;

    if (!_bleReady || writeChar == null) {
      logger.w("BLE not ready — profile not sent");
      return false;
    }

    try {
      final packet = Uint8List(164);
      packet[0] = 0x02;

      // Name: 32 bytes total
      final nameBytes = Uint8List(32);
      final encodedName = name.codeUnits.take(31).toList();
      nameBytes.setRange(0, encodedName.length, encodedName);
      packet.setRange(1, 33, nameBytes);

      // Age and blood group
      packet[33] = age & 0xFF;
      packet[34] = bloodGroup & 0xFF;

      // Medical info: 80 bytes total
      final medicalBytes = Uint8List(80);
      final encodedMedical = medicalInfo.codeUnits.take(79).toList();
      medicalBytes.setRange(0, encodedMedical.length, encodedMedical);
      packet.setRange(35, 115, medicalBytes);

      // Phone count
      final phoneCount = phones.length > 3 ? 3 : phones.length;
      packet[115] = phoneCount;

      // 3 phone slots × 16 bytes each
      for (int i = 0; i < 3; i++) {
        final phoneSlot = Uint8List(16);
        if (i < phones.length) {
          final encodedPhone = phones[i].codeUnits.take(15).toList();
          phoneSlot.setRange(0, encodedPhone.length, encodedPhone);
        }
        packet.setRange(116 + (i * 16), 132 + (i * 16), phoneSlot);
      }

      await writeChar!
          .write(packet, withoutResponse: false)
          .timeout(const Duration(seconds: 5));

      logger.i("✓ Rider profile sent");
      return true;
    } catch (e) {
      logger.e("Profile send failed: $e");
      return false;
    }
  }

  // ==================== DISCONNECT ====================
  Future<void> disconnect() async {
    try {
      logger.i("Disconnecting...");

      _manualDisconnect = true;
      _isConnecting = false;
      _isScanning = false;

      _reconnectTimer?.cancel();
      _gpsCheckTimer?.cancel();
      _scanTimer?.cancel();

      await _scanSubscription?.cancel();
      await _connectionSubscription?.cancel();
      await _notifySubscription?.cancel();

      try {
        bool scanning = await FlutterBluePlus.isScanning.first.timeout(
          const Duration(seconds: 2),
          onTimeout: () => false,
        );
        if (scanning) await FlutterBluePlus.stopScan();
      // ignore: empty_catches
      } catch (e) {}

      if (connectedDevice != null) {
        try {
          await connectedDevice!.disconnect().timeout(
            const Duration(seconds: 5),
          );
        // ignore: empty_catches
        } catch (e) {}
      }

      connectedDevice = null;
      writeChar = null;
      notifyChar = null;

      onStatusChange?.call("Disconnected");
      logger.i("✓ Disconnected");
    } catch (e) {
      logger.e("Disconnect error: $e");
    }
  }

  // ==================== DISPOSE ====================
  Future<void> dispose() async {
    _isDisposed = true;
    _manualDisconnect = true;

    _scanTimer?.cancel();
    _reconnectTimer?.cancel();
    _gpsCheckTimer?.cancel();

    await _scanSubscription?.cancel();
    await _connectionSubscription?.cancel();
    await _notifySubscription?.cancel();

    await stopMobileGPS();
    await disconnect();

    logger.i("✓ Disposed");
  }

  // ==================== GETTERS ====================
  bool get isConnected => connectedDevice != null;
  bool get isScanning => _isScanning;
  bool get isConnecting => _isConnecting;

  String get connectionStatus {
    if (_isDisposed) return "Disposed";
    if (_isConnecting) return "Connecting...";
    if (connectedDevice != null) return "Connected";
    if (_isScanning) return "Scanning...";
    if (_manualDisconnect) return "Disconnected";
    return "Ready";
  }
}
