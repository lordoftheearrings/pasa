import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:pasa/core/components/buttons/app_button.dart';
import 'package:pasa/core/components/inputfield/inputfield.dart';
import 'package:pasa/core/components/text/app_text.dart';
import 'package:pasa/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:pasa/core/constants/app_textstyles.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController controller = MapController(
    initPosition: GeoPoint(latitude: 27.7172, longitude: 85.3240),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        backgroundColor: AppColors.black,
        elevation: 0,
        toolbarHeight: 100,
        title: AppText(
          label: 'MAPS',
          style: AppTextStyles.heading1.copyWith(letterSpacing: 3),
        ),
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: AppButton(
              label: 'SOS',
              onPressed: () {},
              width: 50,
              shouldUseFullWidth: false,
              color: AppColors.tertiary,
              borderRadius: 32,
              textcolor: AppColors.white,
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          OSMFlutter(
            controller: controller,
            osmOption: OSMOption(
              zoomOption: ZoomOption(
                initZoom: 14,
                minZoomLevel: 3,
                maxZoomLevel: 19,
              ),
              showZoomController: true,
              userTrackingOption: UserTrackingOption(
                enableTracking: true,
                unFollowUser: false,
              ),
              showDefaultInfoWindow: true,
            ),
          ),
          Positioned(
            top: 20,
            right: 10,
            left: 10,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.black,
                borderRadius: BorderRadius.circular(12),
              ),
              width: double.infinity,
              child: InputField(labelText: 'Search...', showLabel: false),
            ),
          ),
          Positioned(
            top: 80,
            right: 10,
            child: FloatingActionButton(
              splashColor: AppColors.darkGrey,
              backgroundColor: AppColors.black,
              child: const Icon(Icons.explore, color: AppColors.primary),
              onPressed: () async {
                await controller.rotateMapCamera(0);
              },
            ),
          ),
          Positioned(
            bottom: 20,
            right: 10,
            child: FloatingActionButton(
              backgroundColor: AppColors.black,
              splashColor: AppColors.darkGrey,
              child: const Icon(Icons.my_location, color: AppColors.primary),
              onPressed: () async {
                await controller.currentLocation();
              },
            ),
          ),
        ],
      ),
    );
  }
}
