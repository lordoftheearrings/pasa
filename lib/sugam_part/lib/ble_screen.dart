// ignore_for_file: deprecated_member_use, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'ble_controller.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BleScreen extends StatefulWidget {
  final BleController bleController;

  const BleScreen({super.key, required this.bleController});

  @override
  _BleScreenState createState() => _BleScreenState();
}

class _BleScreenState extends State<BleScreen> with TickerProviderStateMixin {
  String connectionStatus = 'Disconnected';
  bool bluetoothOn = false;
  bool isScanning = false;
  String deviceName = '';
  String deviceId = '';

  // Sensor data
  int alcoholLevel = 0;
  bool helmetWorn = false;
  int heartRate = 0;
  int spO2 = 0;

  late AnimationController _scanAnimationController;
  late AnimationController _connectionPulseController;

  @override
  void initState() {
    super.initState();

    // Animation controllers
    _scanAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _connectionPulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    // Request permissions first
    requestPermissions().then((_) {
      // Then initialize bluetooth
      initializeBluetooth();
    });

    // Initialize with current values from bleController
    _updateStateFromController();

    // Listen to data updates
    widget.bleController.onDataReceived = (_) {
      if (!mounted) return;
      setState(() {
        alcoholLevel = widget.bleController.alcohol;
        helmetWorn = widget.bleController.helmetWorn;
        heartRate = widget.bleController.heartRate;
        spO2 = widget.bleController.spO2;
      });
    };

    // Listen to connection status changes
    widget.bleController.onStatusChange = (status) {
      if (!mounted) return;
      setState(() {
        connectionStatus = status;
        isScanning = status.contains("Scanning");

        // Extract device info if connected
        if (status.contains("Connected") &&
            widget.bleController.connectedDevice != null) {
          deviceName =
              widget.bleController.connectedDevice?.platformName ??
              'Unknown Device';
          deviceId =
              widget.bleController.connectedDevice?.remoteId.toString() ?? '';
        } else if (status.contains("Disconnected")) {
          deviceName = '';
          deviceId = '';
        }
      });
    };
  }

  void _updateStateFromController() {
    setState(() {
      connectionStatus = widget.bleController.connectedDevice != null
          ? "Connected to ${widget.bleController.connectedDevice!.platformName}"
          : "Disconnected";
      deviceName = widget.bleController.connectedDevice?.platformName ?? '';
      deviceId =
          widget.bleController.connectedDevice?.remoteId.toString() ?? '';

      // Update sensor data
      alcoholLevel = widget.bleController.alcohol;
      helmetWorn = widget.bleController.helmetWorn;
      heartRate = widget.bleController.heartRate;
      spO2 = widget.bleController.spO2;
    });
  }

  @override
  void dispose() {
    _scanAnimationController.dispose();
    _connectionPulseController.dispose();
    // DO NOT dispose bleController or disconnect - it's shared across pages
    super.dispose();
  }

  Future<void> requestPermissions() async {
    await [
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.location,
    ].request();
  }

  Future<void> initializeBluetooth() async {
    bool isBtOn = await FlutterBluePlus.isOn;

    if (!isBtOn) {
      try {
        await FlutterBluePlus.turnOn();
        await Future.delayed(const Duration(seconds: 2));
      } catch (_) {}
    }

    isBtOn = await FlutterBluePlus.isOn;
    setState(() {
      bluetoothOn = isBtOn;
    });

    if (isBtOn && widget.bleController.connectedDevice == null) {
      await Future.delayed(const Duration(milliseconds: 500));
      widget.bleController.startAutoScan();
    }

    FlutterBluePlus.adapterState.listen((state) {
      bool isOn = state == BluetoothAdapterState.on;
      if (mounted) {
        setState(() {
          bluetoothOn = isOn;
        });
        if (!isOn) {
          widget.bleController.stopScan();
          setState(() {
            connectionStatus = "Bluetooth OFF";
            isScanning = false;
          });
        } else if (widget.bleController.connectedDevice == null) {
          setState(() {
            connectionStatus = "Bluetooth ON";
          });
          Future.delayed(const Duration(milliseconds: 800), () {
            if (mounted &&
                bluetoothOn &&
                widget.bleController.connectedDevice == null) {
              widget.bleController.startAutoScan();
            }
          });
        }
      }
    });
  }

  void toggleBluetooth() async {
    if (!bluetoothOn) {
      try {
        await FlutterBluePlus.turnOn();
        await Future.delayed(const Duration(seconds: 1));
        bool isBtOn = await FlutterBluePlus.isOn;
        setState(() {
          bluetoothOn = isBtOn;
          if (isBtOn) connectionStatus = "Bluetooth ON";
        });
        if (isBtOn) {
          await Future.delayed(const Duration(milliseconds: 800));
          widget.bleController.startAutoScan();
        }
      } catch (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Unable to turn on Bluetooth"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      await widget.bleController.disconnect();
      await widget.bleController.stopScan();
      setState(() {
        bluetoothOn = false;
        connectionStatus = "Bluetooth OFF";
        isScanning = false;
        deviceName = '';
        deviceId = '';
      });
    }
  }

  void startScan() {
    if (!bluetoothOn) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Turn on Bluetooth first"),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    if (isScanning) return;
    widget.bleController.startAutoScan();
    setState(() => isScanning = true);
  }

  void stopScan() {
    widget.bleController.stopScan();
    setState(() => isScanning = false);
  }

  void disconnectDevice() async {
    await widget.bleController.disconnect();
    setState(() {
      connectionStatus = "Disconnected";
      deviceName = '';
      deviceId = '';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Device disconnected"),
        backgroundColor: Colors.orange,
      ),
    );
  }

  Widget buildConnectionStatusCard() {
    Color statusColor;
    IconData icon;
    String statusLabel;

    if (connectionStatus.contains("Scanning") ||
        connectionStatus.contains("Found")) {
      statusColor = Colors.orange;
      icon = Icons.wifi_tethering_rounded;
      statusLabel = "SEARCHING FOR DEVICE";
    } else if (connectionStatus.contains("Connected")) {
      statusColor = Colors.green;
      icon = Icons.check_circle_rounded;
      statusLabel = "CONNECTED";
    } else if (connectionStatus.contains("Bluetooth ON")) {
      statusColor = Colors.blue;
      icon = Icons.bluetooth;
      statusLabel = "READY TO CONNECT";
    } else {
      statusColor = Colors.red;
      icon = Icons.bluetooth_disabled;
      statusLabel = "OFFLINE";
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [statusColor.withOpacity(0.2), Colors.grey[900]!],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: statusColor.withOpacity(0.4), width: 2),
        boxShadow: [
          BoxShadow(
            color: statusColor.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          AnimatedBuilder(
            animation: isScanning
                ? _scanAnimationController
                : _connectionPulseController,
            builder: (context, child) {
              return Transform.scale(
                scale: isScanning
                    ? 1 + (_scanAnimationController.value * 0.2)
                    : connectionStatus.contains("Connected")
                    ? 1 + (_connectionPulseController.value * 0.1)
                    : 1.0,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.2),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: statusColor.withOpacity(0.4),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Icon(icon, color: statusColor, size: 64),
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          Text(
            statusLabel,
            style: TextStyle(
              color: statusColor,
              fontSize: 14,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            connectionStatus,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDeviceInfoCard() {
    bool isConnected = connectionStatus.contains("Connected");

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isConnected
              ? Colors.green.withOpacity(0.4)
              : Colors.grey.withOpacity(0.2),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: isConnected ? Colors.green : Colors.grey,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                "Device Information",
                style: TextStyle(
                  color: isConnected ? Colors.white : Colors.grey[600],
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            "Device Name:",
            deviceName.isEmpty ? "No device connected" : deviceName,
            isConnected,
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            "Device ID:",
            deviceId.isEmpty ? "---" : deviceId,
            isConnected,
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            "Status:",
            bluetoothOn ? (isConnected ? "Online" : "Ready") : "Offline",
            bluetoothOn,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, bool isActive) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[500],
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.grey[600],
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildControlButton({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
    required Color color,
    bool enabled = true,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: enabled ? onTap : null,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: enabled ? color : Colors.grey[800],
            borderRadius: BorderRadius.circular(16),
            boxShadow: enabled
                ? [
                    BoxShadow(
                      color: color.withOpacity(0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white, size: 32),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isConnected = connectionStatus.contains("Connected");

    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text(
            "Bluetooth Control",
            style: TextStyle(
              color: Colors.green,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: bluetoothOn
                    ? Colors.green.withOpacity(0.2)
                    : Colors.red.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: bluetoothOn ? Colors.green : Colors.red,
                  width: 2,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    bluetoothOn ? Icons.bluetooth : Icons.bluetooth_disabled,
                    color: bluetoothOn ? Colors.green : Colors.red,
                    size: 20,
                  ),
                  Transform.scale(
                    scale: 0.9,
                    child: Switch(
                      value: bluetoothOn,
                      onChanged: (_) {
                        HapticFeedback.lightImpact();
                        toggleBluetooth();
                      },
                      activeColor: Colors.green,
                      activeTrackColor: Colors.green.withOpacity(0.3),
                      inactiveThumbColor: Colors.red,
                      inactiveTrackColor: Colors.red.withOpacity(0.3),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              buildConnectionStatusCard(),
              const SizedBox(height: 20),
              buildDeviceInfoCard(),
              const SizedBox(height: 20),
              Row(
                children: [
                  buildControlButton(
                    label: isScanning ? "Stop Scan" : "Start Scan",
                    icon: isScanning ? Icons.stop : Icons.search,
                    onTap: isScanning ? stopScan : startScan,
                    color: isScanning ? Colors.red : Colors.blue,
                    enabled: bluetoothOn,
                  ),
                  const SizedBox(width: 12),
                  buildControlButton(
                    label: "Disconnect",
                    icon: Icons.link_off,
                    onTap: disconnectDevice,
                    color: Colors.orange,
                    enabled: isConnected,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.lightbulb_outline,
                          color: Colors.yellow[700],
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          "Instructions",
                          style: TextStyle(
                            color: Colors.yellow[700],
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildInstructionItem(
                      "1. Turn on Bluetooth using the toggle",
                    ),
                    _buildInstructionItem(
                      "2. Tap 'Start Scan' to search for devices",
                    ),
                    _buildInstructionItem(
                      "3. The app will auto-connect to 'Smart_Helmet'",
                    ),
                    _buildInstructionItem(
                      "4. Use 'Disconnect' to manually disconnect",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildInstructionItem(String text) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.check_circle, color: Colors.green, size: 16),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    ),
  );
}
