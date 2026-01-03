import 'dart:developer';
import 'package:pasa/core/components/text/app_text.dart';
import 'package:pasa/core/constants/app_colors.dart';
import 'package:pasa/core/constants/app_textstyles.dart';
import 'package:flutter/material.dart';
import 'package:pasa/core/components/inputfield/inputfield.dart';
import 'package:pasa/core/components/buttons/app_button.dart';

class ForgotPasswordSheet extends StatefulWidget {
  const ForgotPasswordSheet({super.key});

  @override
  State<ForgotPasswordSheet> createState() => _ForgotPasswordSheetState();
}

class _ForgotPasswordSheetState extends State<ForgotPasswordSheet> {
  bool usePhoneNumber = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.04,
            right: MediaQuery.of(context).size.width * 0.04,
            top: MediaQuery.of(context).size.height * 0.02,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.1,
                height: 5,
                decoration: BoxDecoration(
                  color: AppColors.hint,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              const SizedBox(height: 16),
              const AppText(
                label: 'Forgot your password?',
                style: AppTextStyles.heading2,
              ),
              const SizedBox(height: 8),
              AppText(
                label: usePhoneNumber
                    ? 'Please enter your phone number where you would like to receive the OTP.'
                    : 'Please enter your email address where you would like to receive the OTP.',
                style: AppTextStyles.greyedOutText,
              ),
              const SizedBox(height: 32),
              usePhoneNumber
                  ? InputField(labelText: "Phone number")
                  : InputField(labelText: "Email"),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  label: 'Send',
                  onPressed: () {
                    usePhoneNumber ? log('otp to phone') : log('otp to email');
                  },
                ),
              ),
              const SizedBox(height: 84),
              InkWell(
                onTap: () {
                  setState(() {
                    usePhoneNumber = !usePhoneNumber;
                  });
                },
                child: AppText(
                  label: usePhoneNumber
                      ? 'Use Email ✉️'
                      : 'Use Phone Number ☎️',
                  style: AppTextStyles.primaryColorText14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> showForgotPasswordSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.black,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
    ),
    builder: (_) => const ForgotPasswordSheet(),
  );
}
