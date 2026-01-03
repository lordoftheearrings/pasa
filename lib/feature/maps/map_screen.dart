import 'package:pasa/core/components/buttons/app_button.dart';
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
      body: Center(child: AppText(label: 'maps')),
    );
  }
}
