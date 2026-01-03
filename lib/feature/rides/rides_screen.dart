import 'package:pasa/core/components/buttons/app_button.dart';
import 'package:pasa/core/components/text/app_text.dart';
import 'package:pasa/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:pasa/core/constants/app_textstyles.dart';

class RidesScreen extends StatefulWidget {
  const RidesScreen({super.key});

  @override
  State<RidesScreen> createState() => _RidesScreenState();
}

class _RidesScreenState extends State<RidesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        backgroundColor: AppColors.black,
        elevation: 0,
        toolbarHeight: 100,
        title: AppText(
          label: 'RIDES',
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
      body: Center(
        child: Column(children: [AppText(label: 'maps')]),
      ),
    );
  }
}
