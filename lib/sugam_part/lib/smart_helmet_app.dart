// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'ble_controller.dart';
import 'home_page.dart';
import 'status_page.dart';
import 'details_page.dart';
import 'map_page.dart';

class SmartHelmetApp extends StatefulWidget {
  final BleController bleController;

  const SmartHelmetApp({super.key, required this.bleController});

  @override
  _SmartHelmetAppState createState() => _SmartHelmetAppState();
}

class _SmartHelmetAppState extends State<SmartHelmetApp> {
  int _currentIndex = 0;

  // List of pages
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    // Initialize pages - ensure they're created once and kept alive
    _pages = [
      HomePage(bleController: widget.bleController),
      StatusPage(bleController: widget.bleController),
      DetailsPage(bleController: widget.bleController),
      MapPage(bleController: widget.bleController),
    ];

    // Auto-start BLE scanning when app launches
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && widget.bleController.connectedDevice == null) {
        widget.bleController.startAutoScan();
      }
    });
  }

  void _onTabTapped(int index) {
    HapticFeedback.lightImpact();
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // Handle back button - prevent accidental exit
      onWillPop: () async {
        if (_currentIndex != 0) {
          // If not on home page, go back to home
          setState(() {
            _currentIndex = 0;
          });
          return false;
        }
        // If on home page, show exit confirmation
        return await _showExitConfirmation(context) ?? false;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: IndexedStack(index: _currentIndex, children: _pages),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.grey[900],
            border: Border(top: BorderSide(color: Colors.grey[800]!, width: 1)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 20,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(icon: Icons.home, label: "Home", index: 0),
                  _buildNavItem(icon: Icons.speed, label: "Status", index: 1),
                  _buildNavItem(
                    icon: Icons.emergency,
                    label: "Emergency",
                    index: 2,
                  ),
                  _buildNavItem(icon: Icons.map, label: "Maps", index: 3),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    bool isSelected = _currentIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => _onTabTapped(index),
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? Colors.green.withOpacity(0.15)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedScale(
                scale: isSelected ? 1.1 : 1.0,
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  icon,
                  color: isSelected ? Colors.green : Colors.grey[600],
                  size: 26,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.green : Colors.grey[600],
                  fontSize: isSelected ? 12 : 11,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool?> _showExitConfirmation(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text(
          'Exit Smart Helmet?',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Are you sure you want to exit? This will disconnect your helmet.',
          style: TextStyle(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancel', style: TextStyle(color: Colors.grey[400])),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Exit', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Clean up when app is closed
    widget.bleController.dispose();
    super.dispose();
  }
}
