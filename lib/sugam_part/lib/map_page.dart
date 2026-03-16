// ignore_for_file: library_private_types_in_public_api

import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'ble_controller.dart';

class MapPage extends StatefulWidget {
  final BleController bleController;

  const MapPage({super.key, required this.bleController});

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> with TickerProviderStateMixin {
  final MapController _mapController = MapController();

  double latitude = 27.7172; // Default to Kathmandu
  double longitude = 85.3240;
  double speed = 0.0; // m/s
  double heading = 0.0; // degrees

  bool isUsingMobileGPS = true;
  bool isTracking = true;
  bool permissionGranted = false;
  bool loading = true;

  List<LatLng> routePoints = [];
  StreamSubscription<Position>? _positionStream;
  Timer? _bleUpdateTimer;

  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _initLocation();
    _startBLEUpdates();
  }

  // ===================== LOCATION =====================
  Future<void> _initLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() => loading = false);
        _showError("Location services are disabled");
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        setState(() => loading = false);
        _showError("Location permission denied");
        return;
      }

      permissionGranted = true;

      // Get initial position
      try {
        final pos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
          timeLimit: const Duration(seconds: 5),
        );
        _updatePosition(pos);
      } catch (e) {
        print("Initial position failed: $e");
      }

      setState(() => loading = false);

      // Start position stream
      _positionStream =
          Geolocator.getPositionStream(
            locationSettings: const LocationSettings(
              accuracy: LocationAccuracy.high,
              distanceFilter: 5,
            ),
          ).listen(
            _updatePosition,
            onError: (error) => print("Position stream error: $error"),
          );
    } catch (e) {
      print("Location init error: $e");
      setState(() => loading = false);
    }
  }

  void _startBLEUpdates() {
    _bleUpdateTimer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      if (!mounted) return;

      // Use helmet GPS if available and not using mobile GPS
      if (!isUsingMobileGPS &&
          widget.bleController.latitude != 0 &&
          widget.bleController.longitude != 0) {
        setState(() {
          latitude = widget.bleController.latitude;
          longitude = widget.bleController.longitude;
        });

        _addRoutePoint(latitude, longitude);

        if (isTracking) {
          _mapController.move(
            LatLng(latitude, longitude),
            _mapController.camera.zoom,
          );
        }
      }
    });
  }

  void _updatePosition(Position pos) {
    if (!mounted || !isUsingMobileGPS) return;

    setState(() {
      latitude = pos.latitude;
      longitude = pos.longitude;
      speed = pos.speed;
      heading = pos.heading;
    });

    _addRoutePoint(latitude, longitude);

    if (isTracking) {
      _mapController.move(
        LatLng(latitude, longitude),
        _mapController.camera.zoom,
      );
    }
  }

  void _addRoutePoint(double lat, double lng) {
    final newPoint = LatLng(lat, lng);

    if (routePoints.isEmpty) {
      routePoints.add(newPoint);
      return;
    }

    // Only add if moved at least 5 meters
    final distance = const Distance().as(
      LengthUnit.Meter,
      routePoints.last,
      newPoint,
    );

    if (distance > 5) {
      setState(() {
        routePoints.add(newPoint);
      });
    }
  }

  // ===================== HELPERS =====================
  double _totalDistance() {
    if (routePoints.length < 2) return 0;

    double distance = 0;
    for (int i = 0; i < routePoints.length - 1; i++) {
      distance += const Distance().as(
        LengthUnit.Kilometer,
        routePoints[i],
        routePoints[i + 1],
      );
    }
    return distance;
  }

  void _recenter() {
    setState(() => isTracking = true);
    _mapController.move(LatLng(latitude, longitude), 17);
  }

  void _toggleSource() {
    setState(() {
      isUsingMobileGPS = !isUsingMobileGPS;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isUsingMobileGPS ? "Using Mobile GPS" : "Using Helmet GPS",
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _clearRoute() {
    setState(() {
      routePoints.clear();
    });
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  // ===================== UI =====================
  @override
  Widget build(BuildContext context) {
    final hasLocation = latitude != 0 && longitude != 0;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Live Tracking",
              style: TextStyle(
                color: Colors.green,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              isUsingMobileGPS ? "Mobile GPS" : "Helmet GPS",
              style: TextStyle(
                color: isUsingMobileGPS ? Colors.blue : Colors.purple,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              isUsingMobileGPS ? Icons.phone_android : Icons.bluetooth,
              color: isUsingMobileGPS ? Colors.blue : Colors.purple,
            ),
            onPressed: _toggleSource,
            tooltip: "Switch GPS Source",
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: routePoints.isEmpty ? null : _clearRoute,
            tooltip: "Clear Route",
          ),
        ],
      ),
      body: loading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(color: Colors.green),
                  const SizedBox(height: 16),
                  Text(
                    "Getting your location...",
                    style: TextStyle(color: Colors.grey[400]),
                  ),
                ],
              ),
            )
          : !permissionGranted
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.location_off, size: 64, color: Colors.grey[600]),
                  const SizedBox(height: 16),
                  Text(
                    "Location permission required",
                    style: TextStyle(color: Colors.grey[400], fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: _initLocation,
                    child: const Text("Grant Permission"),
                  ),
                ],
              ),
            )
          : Stack(
              children: [
                // MAP
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: LatLng(latitude, longitude),
                    initialZoom: 17,
                    minZoom: 3,
                    maxZoom: 19,
                    onMapEvent: (event) {
                      if (event is MapEventMove &&
                          event.source != MapEventSource.mapController) {
                        setState(() => isTracking = false);
                      }
                    },
                  ),
                  children: [
                    // MAP TILES - OpenStreetMap
                    TileLayer(
                      urlTemplate:
                          "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                      userAgentPackageName: 'com.example.smarthelmet',
                    ),

                    // ROUTE LINE
                    if (routePoints.length > 1)
                      PolylineLayer(
                        polylines: [
                          Polyline(
                            points: routePoints,
                            strokeWidth: 5,
                            color: Colors.blue,
                            borderColor: Colors.white,
                            borderStrokeWidth: 2,
                          ),
                        ],
                      ),

                    // CURRENT LOCATION MARKER
                    if (hasLocation)
                      MarkerLayer(
                        markers: [
                          Marker(
                            width: 100,
                            height: 100,
                            point: LatLng(latitude, longitude),
                            child: AnimatedBuilder(
                              animation: _pulseController,
                              builder: (_, __) {
                                final scale = 1 + _pulseController.value * 0.3;
                                return Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    // Pulse effect
                                    Transform.scale(
                                      scale: scale,
                                      child: Container(
                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.blue.withOpacity(0.2),
                                        ),
                                      ),
                                    ),
                                    // Direction arrow
                                    if (speed > 0.5)
                                      Transform.rotate(
                                        angle: heading * math.pi / 180,
                                        child: const Icon(
                                          Icons.navigation,
                                          size: 36,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    // Center dot
                                    Container(
                                      width: 14,
                                      height: 14,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.blue,
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 3,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                  ],
                ),

                // RECENTER BUTTON
                if (hasLocation && !isTracking)
                  Positioned(
                    right: 16,
                    bottom: routePoints.length > 1 ? 180 : 100,
                    child: FloatingActionButton(
                      onPressed: _recenter,
                      backgroundColor: Colors.blue,
                      child: const Icon(Icons.my_location, color: Colors.white),
                    ),
                  ),

                // STATS CARD
                if (routePoints.length > 1)
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.blue.withOpacity(0.3),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatColumn(
                            "DISTANCE",
                            "${_totalDistance().toStringAsFixed(2)} km",
                            Icons.straighten,
                            Colors.green,
                          ),
                          Container(
                            width: 1,
                            height: 40,
                            color: Colors.grey[700],
                          ),
                          _buildStatColumn(
                            "SPEED",
                            "${(speed * 3.6).toStringAsFixed(1)} km/h",
                            Icons.speed,
                            Colors.orange,
                          ),
                          Container(
                            width: 1,
                            height: 40,
                            color: Colors.grey[700],
                          ),
                          _buildStatColumn(
                            "POINTS",
                            routePoints.length.toString(),
                            Icons.location_on,
                            Colors.blue,
                          ),
                        ],
                      ),
                    ),
                  ),

                // GPS STATUS INDICATOR
                Positioned(
                  top: 16,
                  left: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: hasLocation ? Colors.green : Colors.red,
                        width: 2,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          hasLocation ? Icons.gps_fixed : Icons.gps_off,
                          color: hasLocation ? Colors.green : Colors.red,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          hasLocation ? "GPS Active" : "No GPS",
                          style: TextStyle(
                            color: hasLocation ? Colors.green : Colors.red,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildStatColumn(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w900,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[500],
            fontSize: 10,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _positionStream?.cancel();
    _bleUpdateTimer?.cancel();
    super.dispose();
  }
}
