// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pasa/core/constants/app_colors.dart';
import 'package:pasa/core/constants/app_images.dart';
import 'package:pasa/core/top_level/di.dart';
import 'package:pasa/sugam_part/lib/details_page.dart';
import 'ble_controller.dart';
import 'ble_screen.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  final BleController bleController;

  const HomePage({super.key, required this.bleController});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  bool helmetWorn = false;
  bool alcoholDetected = false;
  bool gpsActive = false;
  bool isConnected = false;
  bool rideStarted = false;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Initialize state from bleController
    _updateStateFromController();

    // Set up callbacks
    _setupCallbacks();
  }

  void _startRide() {
    HapticFeedback.mediumImpact();
    setState(() {
      rideStarted = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Ride Started! 🏍️"),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
    getIt<BleController>().startRide();
  }

  void _endRide() {
    HapticFeedback.mediumImpact();
    setState(() {
      rideStarted = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Ride Ended! 🛑"),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ),
    );
    getIt<BleController>().endRide();
  }

  void _setupCallbacks() {
    // Listen to data from ESP32
    widget.bleController.onDataReceived = (_) {
      if (!mounted) return;
      _updateStateFromController();
    };

    // Listen to connection status
    widget.bleController.onStatusChange = (status) {
      if (!mounted) return;
      setState(() {
        isConnected = status.contains("Connected");
      });
    };
  }

  @override
  void didUpdateWidget(HomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Re-setup callbacks when widget updates
    _setupCallbacks();
    _updateStateFromController();
  }

  void _updateStateFromController() {
    setState(() {
      // Check if actually connected
      isConnected = widget.bleController.connectedDevice != null;

      // Update helmet status
      helmetWorn = widget.bleController.helmetWorn;

      // Alcohol detected if level > 50
      alcoholDetected = widget.bleController.alcohol > 50;

      // GPS active if coordinates are not 0
      gpsActive =
          widget.bleController.latitude != 0.0 &&
          widget.bleController.longitude != 0.0;
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Widget _buildStatusIcon({
    required IconData icon,
    required String label,
    required bool isActive,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      height: 80,
      width: 80,
      decoration: BoxDecoration(
        color: isActive
            ? Colors.green.withOpacity(0.2)
            : Colors.red.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isActive
              ? Colors.green.withOpacity(0.6)
              : Colors.red.withOpacity(0.6),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: isActive
                ? Colors.green.withOpacity(0.3)
                : Colors.red.withOpacity(0.3),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isActive ? Colors.green : Colors.red, size: 24),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isActive ? Colors.green : Colors.red,
              fontSize: 9,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildChecklistItem(String label, bool checked) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            checked ? Icons.check_circle : Icons.cancel,
            color: checked ? Colors.green : Colors.red,
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: checked ? Colors.white : Colors.grey[600],
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Can start ride if: helmet worn AND no alcohol detected AND GPS active
    bool canStartRide =
        helmetWorn && !alcoholDetected && gpsActive && isConnected;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.black,
        elevation: 0,
        toolbarHeight: 100,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "PASA",
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "Portable Automated SOS Alert",
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: isConnected
                            ? Colors.green.withOpacity(0.2)
                            : Colors.grey.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: isConnected ? Colors.green : Colors.grey,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            isConnected ? "ONLINE" : "OFFLINE",
                            style: TextStyle(
                              color: isConnected ? Colors.green : Colors.grey,
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 4),
                    Align(
                      alignment: AlignmentGeometry.centerRight,
                      child: Text(
                        'Hello, Rider',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ProfilePage()),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      shape: BoxShape.circle,
                    ),
                    child: SizedBox(
                      height: 50,
                      width: 50,
                      child: Image.asset(AppImages.helmet, fit: BoxFit.contain),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          // Background with helmet image
          // Positioned.fill(
          //   child: Container(
          //     decoration: BoxDecoration(
          //       gradient: LinearGradient(
          //         begin: Alignment.topCenter,
          //         end: Alignment.bottomCenter,
          //         colors: [
          //           Colors.grey[900]!.withOpacity(0.8),
          //           Colors.black.withOpacity(0.95),
          //           Colors.black,
          //         ],
          //       ),
          //     ),
          //     child: Opacity(
          //       opacity: 0.1,
          //       child: Image.network(
          //         'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=800',
          //         fit: BoxFit.cover,
          //         errorBuilder: (context, error, stackTrace) {
          //           return Center(
          //             child: Icon(
          //               Icons.sports_motorsports,
          //               size: 200,
          //               color: Colors.grey[800],
          //             ),
          //           );
          //         },
          //       ),
          //     ),
          //   ),
          // ),
          Offstage(
            offstage: true, // hidden, but still in the tree
            child: ProfilePage(key: ProfilePage.profileKey),
          ),
          Offstage(
            offstage: true,
            child: DetailsPage(
              key: DetailsPage.detailsKey,
              bleController: BleController(),
            ),
          ),
          Positioned(
            top: 0,
            left: -MediaQuery.of(context).size.width * 0.01,
            child: Opacity(
              opacity: 0.8,
              child: SizedBox(
                height: 450,
                width: 300,

                child: Image.asset(AppImages.helmetHome, fit: BoxFit.contain),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // TITLE ROW
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Expanded(
                    //       child: Column(
                    //         crossAxisAlignment: CrossAxisAlignment.start,
                    //         children: [
                    //           const Text(
                    //             "PASA",
                    //             style: TextStyle(
                    //               color: Colors.green,
                    //               fontSize: 28,
                    //               fontWeight: FontWeight.w900,
                    //               letterSpacing: 2,
                    //             ),
                    //           ),
                    //           const SizedBox(height: 2),
                    //           Text(
                    //             "Safety First, Always",
                    //             style: TextStyle(
                    //               color: Colors.grey[400],
                    //               fontSize: 12,
                    //               fontWeight: FontWeight.w500,
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //     Row(
                    //       children: [
                    //         Container(
                    //           padding: const EdgeInsets.symmetric(
                    //             horizontal: 10,
                    //             vertical: 5,
                    //           ),
                    //           decoration: BoxDecoration(
                    //             color: isConnected
                    //                 ? Colors.green.withOpacity(0.2)
                    //                 : Colors.grey.withOpacity(0.2),
                    //             borderRadius: BorderRadius.circular(20),
                    //           ),
                    //           child: Row(
                    //             mainAxisSize: MainAxisSize.min,
                    //             children: [
                    //               Container(
                    //                 width: 6,
                    //                 height: 6,
                    //                 decoration: BoxDecoration(
                    //                   color: isConnected
                    //                       ? Colors.green
                    //                       : Colors.grey,
                    //                   shape: BoxShape.circle,
                    //                 ),
                    //               ),
                    //               const SizedBox(width: 6),
                    //               Text(
                    //                 isConnected ? "ONLINE" : "OFFLINE",
                    //                 style: TextStyle(
                    //                   color: isConnected
                    //                       ? Colors.green
                    //                       : Colors.grey,
                    //                   fontSize: 9,
                    //                   fontWeight: FontWeight.w700,
                    //                 ),
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //         const SizedBox(width: 10),
                    //         GestureDetector(
                    //           onTap: () {
                    //             Navigator.push(
                    //               context,
                    //               MaterialPageRoute(
                    //                 builder: (_) => const ProfilePage(),
                    //               ),
                    //             );
                    //           },
                    //           child: Container(
                    //             padding: const EdgeInsets.all(8),
                    //             decoration: BoxDecoration(
                    //               color: Colors.grey[800],
                    //               shape: BoxShape.circle,
                    //             ),
                    //             child: const Icon(
                    //               Icons.person,
                    //               color: Colors.white,
                    //               size: 24,
                    //             ),
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ],
                    // ),
                    const SizedBox(height: 24),

                    // STATUS ICONS
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Column(
                          children: [
                            // HELMET ICON: Green when worn, Red when not worn
                            _buildStatusIcon(
                              icon: Icons.sports_motorsports,
                              label: "HELMET",
                              isActive: helmetWorn,
                            ),
                            const SizedBox(height: 12),

                            // ALCOHOL ICON: Green when NOT detected (safe), Red when detected
                            _buildStatusIcon(
                              icon: Icons.local_drink,
                              label: "ALCOHOL",
                              isActive: !alcoholDetected, // Green = no alcohol
                            ),
                            const SizedBox(height: 12),

                            // GPS ICON: Green when active, Red when inactive
                            _buildStatusIcon(
                              icon: Icons.gps_fixed,
                              label: "GPS",
                              isActive: gpsActive,
                            ),
                            const SizedBox(height: 12),

                            // BLUETOOTH ICON: Green when connected, Red when disconnected
                            GestureDetector(
                              onTap: () async {
                                WidgetsBinding.instance.addPostFrameCallback((
                                  _,
                                ) async {
                                  await ProfilePage.profileKey.currentState
                                      ?.loadProfileAndSendToBle();
                                  await DetailsPage.detailsKey.currentState
                                      ?.loadContactsAndSyncToBle();
                                });
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => BleScreen(
                                      bleController: widget.bleController,
                                    ),
                                  ),
                                ).then((_) {
                                  // Re-setup callbacks and refresh state when coming back
                                  _setupCallbacks();
                                  _updateStateFromController();
                                });
                              },
                              child: _buildStatusIcon(
                                icon: Icons.bluetooth,
                                label: "BLE",
                                isActive: isConnected,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // START BUTTON
                    // AnimatedBuilder(
                    //   animation: _pulseAnimation,
                    //   builder: (context, _) {
                    //     return Transform.scale(
                    //       scale: canStartRide ? _pulseAnimation.value : 1.0,
                    //       child: GestureDetector(
                    //         onTap: () {
                    //           if (canStartRide) {
                    //             HapticFeedback.mediumImpact();
                    //             ScaffoldMessenger.of(context).showSnackBar(
                    //               const SnackBar(
                    //                 content: Text("Ride Started! 🏍️"),
                    //                 backgroundColor: Colors.green,
                    //                 duration: Duration(seconds: 2),
                    //               ),
                    //             );
                    //           } else {
                    //             HapticFeedback.lightImpact();

                    //             // Show specific reason why ride can't start
                    //             String reason = "";
                    //             if (!isConnected) {
                    //               reason =
                    //                   "Please connect to helmet via Bluetooth";
                    //             } else if (!helmetWorn) {
                    //               reason = "Please wear your helmet";
                    //             } else if (alcoholDetected) {
                    //               reason =
                    //                   "Alcohol detected! Riding not allowed";
                    //             } else if (!gpsActive) {
                    //               reason = "Waiting for GPS signal";
                    //             }

                    //             ScaffoldMessenger.of(context).showSnackBar(
                    //               SnackBar(
                    //                 content: Text(reason),
                    //                 backgroundColor: Colors.red[700],
                    //                 duration: const Duration(seconds: 2),
                    //               ),
                    //             );
                    //           }
                    //         },
                    //         child: Container(
                    //           width: double.infinity,
                    //           padding: const EdgeInsets.symmetric(vertical: 18),
                    //           decoration: BoxDecoration(
                    //             gradient: canStartRide
                    //                 ? LinearGradient(
                    //                     colors: [
                    //                       Colors.green[600]!,
                    //                       Colors.green[400]!,
                    //                     ],
                    //                   )
                    //                 : LinearGradient(
                    //                     colors: [
                    //                       Colors.grey[800]!,
                    //                       Colors.grey[700]!,
                    //                     ],
                    //                   ),
                    //             borderRadius: BorderRadius.circular(16),
                    //             boxShadow: canStartRide
                    //                 ? [
                    //                     BoxShadow(
                    //                       color: Colors.green.withOpacity(0.4),
                    //                       blurRadius: 20,
                    //                       spreadRadius: 2,
                    //                     ),
                    //                   ]
                    //                 : null,
                    //           ),
                    //           child: Center(
                    //             child: Text(
                    //               canStartRide ? "START RIDE" : "RIDE LOCKED",
                    //               style: const TextStyle(
                    //                 color: Colors.white,
                    //                 fontSize: 20,
                    //                 fontWeight: FontWeight.w900,
                    //               ),
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //     );
                    //   },
                    // ),
                    AnimatedBuilder(
                      animation: _pulseAnimation,
                      builder: (context, _) {
                        return Transform.scale(
                          scale: canStartRide && !rideStarted
                              ? _pulseAnimation.value
                              : 1.0,
                          child: GestureDetector(
                            onTap: () {
                              if (canStartRide && !rideStarted) {
                                _startRide();
                              } else if (rideStarted) {
                                _endRide();
                              } else {
                                HapticFeedback.lightImpact();
                                String reason = "";
                                if (!isConnected) {
                                  reason =
                                      "Please connect to helmet via Bluetooth";
                                } else if (!helmetWorn) {
                                  reason = "Please wear your helmet";
                                } else if (alcoholDetected) {
                                  reason =
                                      "Alcohol detected! Riding not allowed";
                                } else if (!gpsActive) {
                                  reason = "Waiting for GPS signal";
                                }
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(reason),
                                    backgroundColor: Colors.red[700],
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              }
                            },
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              decoration: BoxDecoration(
                                gradient: canStartRide && !rideStarted
                                    ? LinearGradient(
                                        colors: [
                                          Colors.green[600]!,
                                          Colors.green[400]!,
                                        ],
                                      )
                                    : rideStarted
                                    ? LinearGradient(
                                        colors: [
                                          Colors.red[600]!,
                                          Colors.red[400]!,
                                        ],
                                      )
                                    : LinearGradient(
                                        colors: [
                                          Colors.grey[800]!,
                                          Colors.grey[700]!,
                                        ],
                                      ),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: canStartRide && !rideStarted
                                    ? [
                                        BoxShadow(
                                          color: Colors.green.withOpacity(0.4),
                                          blurRadius: 20,
                                          spreadRadius: 2,
                                        ),
                                      ]
                                    : rideStarted
                                    ? [
                                        BoxShadow(
                                          color: Colors.red.withOpacity(0.4),
                                          blurRadius: 20,
                                          spreadRadius: 2,
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Center(
                                child: Text(
                                  rideStarted
                                      ? "END RIDE"
                                      : canStartRide
                                      ? "START RIDE"
                                      : "RIDE LOCKED",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),

                    // CHECKLIST
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "SAFETY CHECKLIST",
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 10),
                          _buildChecklistItem(
                            "Bluetooth Connected",
                            isConnected,
                          ),
                          _buildChecklistItem("Helmet Worn", helmetWorn),
                          _buildChecklistItem(
                            "No Alcohol Detected",
                            !alcoholDetected,
                          ),
                          _buildChecklistItem("GPS Active", gpsActive),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // DEBUG INFO (Optional - Remove in production)
                    if (isConnected)
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.grey[850],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.grey[700]!,
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "SENSOR DATA",
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 8),
                            _buildDebugRow(
                              "Alcohol Level",
                              "${widget.bleController.alcohol}%",
                            ),
                            _buildDebugRow(
                              "Helmet Status",
                              helmetWorn ? "Worn" : "Not Worn",
                            ),
                            _buildDebugRow(
                              "GPS",
                              "${widget.bleController.latitude.toStringAsFixed(4)}, ${widget.bleController.longitude.toStringAsFixed(4)}",
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDebugRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
