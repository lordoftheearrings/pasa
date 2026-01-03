import 'package:pasa/core/components/text/app_text.dart';
import 'package:pasa/core/constants/app_colors.dart';
import 'package:pasa/core/constants/app_textstyles.dart';
import 'package:flutter/material.dart';

class AppOutlinedbutton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool shouldUseFullWidth;
  final double borderWidth;
  final bool isLoading;
  final bool isDisabled;
  final double verticalPadding;
  final Widget? leading;
  final TextStyle? textStyle;
  const AppOutlinedbutton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.shouldUseFullWidth = true,
    this.borderWidth = 1.5,
    this.verticalPadding = 12.0,
    this.leading,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.0,
      width: shouldUseFullWidth ? double.infinity : null,
      child: OutlinedButton(
        onPressed: isDisabled || isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: verticalPadding),
          side: BorderSide(
            width: borderWidth,
            color: isDisabled ? AppColors.hint : AppColors.white,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), 
          ),
        ),
        child: isLoading
            ? const SizedBox(
                height: 16,
                width: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (leading != null) ...[leading!, const SizedBox(width: 8)],
                  AppText(
                    label: label,
                    style:
                        textStyle ??
                        (isDisabled
                            ? AppTextStyles.outlinedbuttonText.copyWith(
                                color: AppColors.hint,
                              )
                            : AppTextStyles.outlinedbuttonText),
                  ),
                ],
              ),
      ),
    );
  }
}
