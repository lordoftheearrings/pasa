import 'package:pasa/core/components/buttons/app_button.dart';
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [AppButton(label: 'label', onPressed: () {})],
            ),
          ),
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.35,
          decoration: BoxDecoration(
            color: AppColors.secondary,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppText(
                  label: 'Emergency Contacts',
                  textAlign: TextAlign.left,
                  style: AppTextStyles.bodyTextSemiBold.copyWith(
                    color: AppColors.darkGrey,
                  ),
                ),
                SizedBox(height: 16),
                Material(                  
                  color: AppColors.tertiary,
                  borderRadius: BorderRadius.circular(16),
                  child: AppText(label: 'label'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
