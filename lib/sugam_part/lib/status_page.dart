// ignore_for_file: library_private_types_in_public_api, deprecated_member_use, unused_element

import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:async';
import 'ble_controller.dart';

class StatusPage extends StatefulWidget {
  final BleController bleController;

  const StatusPage({super.key, required this.bleController});

  @override
  _StatusPageState createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> with TickerProviderStateMixin {
  int heartRate = 0;
  int spO2 = 0;
  List<int> heartRateHistory = [];
  List<int> spO2History = [];
  final int maxHistoryLength = 30;

  // Accelerometer & Gyroscope (now using real data from BLE)
  double accelX = 0.0;
  double accelY = 0.0;
  double accelZ = 0.0;
  double gyroX = 0.0;
  double gyroY = 0.0;
  double gyroZ = 0.0;

  String rideStatus = "Stationary";
  String activityType = "Unknown";
  double tiltAngle = 0.0;
  double estimatedSpeed = 0.0; // km/h
  double turnRate = 0.0; // deg/s

  // For speed estimation
  List<double> accelHistory = [];
  final int speedHistoryLength = 10;

  late AnimationController _heartBeatController;
  Timer? _dataUpdateTimer;

  @override
  void initState() {
    super.initState();

    _heartBeatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat();

    // Method 1: Set callback (original approach)
    widget.bleController.onDataReceived = (data) {
      if (!mounted) return;
      print("📱 Callback triggered!");
      _updateAllData();
    };

    // Method 2: Poll data periodically (backup approach)
    _dataUpdateTimer = Timer.periodic(const Duration(milliseconds: 500), (
      timer,
    ) {
      if (!mounted) return;
      _updateAllData();
    });

    // Initial update
    _updateAllData();
  }

  void _updateAllData() {
    if (!mounted) return;

    setState(() {


      // Update history
      if (heartRate > 0) {
        heartRateHistory.add(heartRate);
        if (heartRateHistory.length > maxHistoryLength) {
          heartRateHistory.removeAt(0);
        }
      }
      if (spO2 > 0) {
        spO2History.add(spO2);
        if (spO2History.length > maxHistoryLength) {
          spO2History.removeAt(0);
        }
      }

      // Get real sensor data from BLE controller
      _updateSensorData();
    });
  }

  void _updateSensorData() {
    // Get REAL data from BLE controller (not simulated!)
    accelX = widget.bleController.accX;
    accelY = widget.bleController.accY;
    accelZ = widget.bleController.accZ;
    gyroX = widget.bleController.gyroX;
    gyroY = widget.bleController.gyroY;
    gyroZ = widget.bleController.gyroZ;

    // Calculate total acceleration (movement intensity)
    double totalAccel = math.sqrt(accelX * accelX + accelY * accelY);

    // Calculate tilt angle (degrees from vertical)
    tiltAngle = math.atan2(accelX, accelZ) * 180 / math.pi;

    // Calculate turn rate from gyroscope
    turnRate = math.sqrt(gyroX * gyroX + gyroY * gyroY + gyroZ * gyroZ);

    // Estimate speed based on acceleration magnitude
    accelHistory.add(totalAccel);
    if (accelHistory.length > speedHistoryLength) {
      accelHistory.removeAt(0);
    }

    // Average acceleration for smoother speed estimate
    double avgAccel = accelHistory.isEmpty
        ? 0
        : accelHistory.reduce((a, b) => a + b) / accelHistory.length;

    // Simple speed estimation (approximate)
    estimatedSpeed = (avgAccel * 30).clamp(0, 120);

    // Determine ride status
    if (totalAccel < 0.3) {
      rideStatus = "Stationary";
      activityType = "Parked";
    } else if (totalAccel < 0.8) {
      rideStatus = "Moving Slowly";
      activityType = "Walking";
    } else if (totalAccel < 1.5) {
      rideStatus = "Riding";
      activityType = "Cruising";
    } else if (totalAccel < 2.5) {
      rideStatus = "Fast Riding";
      activityType = "Speeding";
    } else {
      rideStatus = "Aggressive Riding";
      activityType = "Dangerous";
    }

    // Detect turns
    if (turnRate > 50) {
      activityType = "Sharp Turn";
    } else if (turnRate > 20) {
      activityType = "Turning";
    }
  }

  @override
  void dispose() {
    _heartBeatController.dispose();
    _dataUpdateTimer?.cancel();
    super.dispose();
  }

  Color _getHeartRateColor() {
    if (heartRate == 0) return Colors.grey;
    if (heartRate < 60) return Colors.blue;
    if (heartRate < 100) return Colors.green;
    if (heartRate < 120) return Colors.orange;
    return Colors.red;
  }

  Color _getSpO2Color() {
    if (spO2 == 0) return Colors.grey;
    if (spO2 >= 95) return Colors.green;
    if (spO2 >= 90) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        elevation: 0,
        title: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Status",
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                widget.bleController.connectionStatus,
                style: TextStyle(
                  color: widget.bleController.isConnected
                      ? Colors.green
                      : Colors.red,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Heart Rate Section
            const SizedBox(height: 16),

            // // Heart Rate Chart
            // _buildChartCard(
            //   label: "Heart Rate Monitor",
            //   data: heartRateHistory,
            //   color: Colors.red,
            //   minY: 40,
            //   maxY: 160,
            // ),

            // const SizedBox(height: 24),

            // // SpO2 Section
            // _buildVitalCard(
            //   label: "BLOOD OXYGEN (SpO2)",
            //   value: spO2 > 0 ? spO2.toString() : "--",
            //   unit: "%",
            //   icon: Icons.air,
            //   color: _getSpO2Color(),
            //   animate: false,
            // ),

            // const SizedBox(height: 16),

            // // SpO2 Chart
            // _buildChartCard(
            //   label: "SpO2 Monitor",
            //   data: spO2History,
            //   color: Colors.blue,
            //   minY: 80,
            //   maxY: 100,
            // ),

            // const SizedBox(height: 24),

            // Ride Status Section
            Text(
              "RIDE STATUS",
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 14,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 12),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.purple.withOpacity(0.3),
                  width: 1.5,
                ),
              ),
              child: Column(
                children: [
                  Icon(Icons.directions_bike, color: Colors.purple, size: 48),
                  const SizedBox(height: 12),
                  Text(
                    rideStatus,
                    style: const TextStyle(
                      color: Colors.purple,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    activityType,
                    style: TextStyle(
                      color: Colors.purple.withOpacity(0.7),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Motion Analytics Row
            Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    label: "TILT ANGLE",
                    value: tiltAngle.toStringAsFixed(1),
                    unit: "°",
                    icon: Icons.rotate_90_degrees_ccw,
                    color: Colors.teal,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMetricCard(
                    label: "EST. SPEED",
                    value: estimatedSpeed.toStringAsFixed(0),
                    unit: "km/h",
                    icon: Icons.speed,
                    color: Colors.amber,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Turn Rate Card
            _buildMetricCard(
              label: "TURN RATE",
              value: turnRate.toStringAsFixed(1),
              unit: "°/s",
              icon: Icons.rotate_right,
              color: Colors.pink,
            ),

            const SizedBox(height: 16),

            // Accelerometer Data (REAL DATA FROM ESP32)
            _buildSensorDataCard(
              title: "ACCELEROMETER",
              icon: Icons.speed,
              color: Colors.orange,
              data: [
                {"label": "X", "value": accelX.toStringAsFixed(2)},
                {"label": "Y", "value": accelY.toStringAsFixed(2)},
                {"label": "Z", "value": accelZ.toStringAsFixed(2)},
              ],
            ),

            const SizedBox(height: 16),

            // Gyroscope Data (REAL DATA FROM ESP32)
            _buildSensorDataCard(
              title: "GYROSCOPE",
              icon: Icons.rotate_right,
              color: Colors.cyan,
              data: [
                {"label": "X", "value": gyroX.toStringAsFixed(2)},
                {"label": "Y", "value": gyroY.toStringAsFixed(2)},
                {"label": "Z", "value": gyroZ.toStringAsFixed(2)},
              ],
            ),
            // const SizedBox(height: 16),
            // _buildVitalCard(
            //   label: "HEART RATE",
            //   value: heartRate > 0 ? heartRate.toString() : "--",
            //   unit: "BPM",
            //   icon: Icons.favorite,
            //   color: _getHeartRateColor(),
            //   animate: true,
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildVitalCard({
    required String label,
    required String value,
    required String unit,
    required IconData icon,
    required Color color,
    required bool animate,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3), width: 2),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 12,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 16),
          animate
              ? AnimatedBuilder(
                  animation: _heartBeatController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: 1.0 + (_heartBeatController.value * 0.1),
                      child: Icon(icon, color: color, size: 64),
                    );
                  },
                )
              : Icon(icon, color: color, size: 64),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: TextStyle(
                  color: color,
                  fontSize: 56,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  unit,
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChartCard({
    required String label,
    required List<int> data,
    required Color color,
    required int minY,
    required int maxY,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 100,
            child: data.isEmpty
                ? Center(
                    child: Text(
                      "Waiting for data...",
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                  )
                : CustomPaint(
                    painter: LinePainter(data, color, minY, maxY),
                    size: const Size(double.infinity, 100),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard({
    required String label,
    required String value,
    required String unit,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3), width: 1.5),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: TextStyle(
                  color: color,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(width: 4),
              Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: Text(
                  unit,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSensorDataCard({
    required String title,
    required IconData icon,
    required Color color,
    required List<Map<String, String>> data,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  color: color,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: data.map((item) {
              return Column(
                children: [
                  Text(
                    item["label"]!,
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item["value"]!,
                    style: TextStyle(
                      color: color,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

// Line Chart Painter
class LinePainter extends CustomPainter {
  final List<int> data;
  final Color color;
  final int minY;
  final int maxY;

  LinePainter(this.data, this.color, this.minY, this.maxY);

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..color = color.withOpacity(0.15)
      ..style = PaintingStyle.fill;

    final path = Path();
    final fillPath = Path();

    final stepX = size.width / (data.length - 1).clamp(1, double.infinity);

    for (int i = 0; i < data.length; i++) {
      final x = i * stepX;
      final normalizedY =
          (data[i] - minY) / (maxY - minY).clamp(1, double.infinity);
      final y = size.height - (normalizedY * size.height).clamp(0, size.height);

      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, size.height);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
    }

    fillPath.lineTo(size.width, size.height);
    fillPath.close();

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, paint);

    // Draw dots
    for (int i = 0; i < data.length; i++) {
      final x = i * stepX;
      final normalizedY =
          (data[i] - minY) / (maxY - minY).clamp(1, double.infinity);
      final y = size.height - (normalizedY * size.height).clamp(0, size.height);

      canvas.drawCircle(
        Offset(x, y),
        4,
        Paint()
          ..color = color
          ..style = PaintingStyle.fill,
      );
    }
  }

  @override
  bool shouldRepaint(LinePainter oldDelegate) => true;
}
