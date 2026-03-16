import 'package:pasa/core/components/text/app_text.dart';
import 'package:pasa/core/constants/app_textstyles.dart';
import 'package:flutter/material.dart';
import 'package:pasa/core/constants/app_colors.dart';

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool shouldUseFullWidth;
  final Color? color;
  final Color? textcolor;
  final double borderRadius;
  final bool isDisabled;
  final double? width;
  final double? height;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.shouldUseFullWidth = true,
    this.color = AppColors.primary,
    this.textcolor = AppColors.black,
    this.borderRadius = 10,
    this.isDisabled = false,
    this.width,
    this.height = 50,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: shouldUseFullWidth ? double.infinity : width,
      child: ElevatedButton(
        onPressed: isDisabled || isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isDisabled ? AppColors.tertiary : color,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),

        child: isLoading
            ? const SizedBox(
                height: 16,
                width: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.white,
                ),
              )
            : AppText(
                label: label,
                style:
                    (isDisabled
                            ? AppTextStyles.bodyText16
                            : AppTextStyles.buttonText)
                        .copyWith(color: textcolor),
              ),
      ),
    );
  }
}
