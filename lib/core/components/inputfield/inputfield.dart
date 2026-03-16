import 'package:pasa/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final String labelText;
  final String? hintText;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final Color labelColor;
  final Color borderColor;
  final Color focusedBorderColor;
  final double focusedBorderWidth;
  final double borderWidth;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final double? width;
  final bool shouldUseFullWidth;
  final bool showLabel;

  const InputField({
    super.key,
    required this.labelText,
    this.hintText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.controller,
    this.labelColor = AppColors.hint,
    this.borderColor = AppColors.hint,
    this.shouldUseFullWidth = true,
    this.showLabel = true,
    this.focusedBorderColor = AppColors.primary,
    this.focusedBorderWidth = 2.0,
    this.borderWidth = 1.0,
    this.prefixIcon,
    this.suffixIcon,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: shouldUseFullWidth ? double.infinity : width,
      child: TextFormField(
        onTapOutside: (_) {
          FocusScope.of(context).unfocus();
        },
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: showLabel ? labelText : null,
          labelStyle: TextStyle(color: labelColor),
          hintText: labelText,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),

            borderSide: BorderSide(
              color: focusedBorderColor,
              width: focusedBorderWidth,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),

            borderSide: BorderSide(color: borderColor, width: borderWidth),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),

            borderSide: BorderSide(color: AppColors.error, width: borderWidth),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),

            borderSide: BorderSide(
              color: AppColors.error,
              width: focusedBorderWidth,
            ),
          ),
        ),
        validator: validator,
      ),
    );
  }
}
