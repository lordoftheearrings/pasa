import 'package:pasa/core/components/text/app_text.dart';
import 'package:pasa/core/constants/app_colors.dart';
import 'package:pasa/core/constants/app_images.dart';
import 'package:flutter/material.dart';
import 'package:pasa/core/constants/app_textstyles.dart';

class SafetyScreen extends StatefulWidget {
  const SafetyScreen({super.key});

  @override
  State<SafetyScreen> createState() => _SafetyScreenState();
}

class _SafetyScreenState extends State<SafetyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        backgroundColor: AppColors.black,
        elevation: 0,
        toolbarHeight: 100,
        title: AppText(
          label: 'SAFETY',
          style: AppTextStyles.heading1.copyWith(letterSpacing: 3),
        ),
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                SizedBox(
                  height: 60,
                  width: 60,
                  child: Image.asset(AppImages.logo, fit: BoxFit.contain),
                ),
                SizedBox(
                  height: 60,
                  width: 60,
                  child: Image.asset(AppImages.appName, fit: BoxFit.contain),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Center(child: AppText(label: 'maps')),
    );
  }
}
