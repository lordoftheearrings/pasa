import 'package:pasa/core/constants/app_textstyles.dart';
import 'package:flutter/material.dart';
import 'package:pasa/core/constants/app_colors.dart';
import 'package:pasa/core/constants/app_fonts.dart';

class AppText extends StatelessWidget {
  final String label;
  final TextStyle? style;
  final TextAlign textAlign;
  final double fontSize;
  final Color color;
  final String? fontFamily;
  final FontWeight fontWeight;
  final double letterSpacing;
  final double wordSpacing;
  final bool underline;

  const AppText({
    super.key,
    required this.label,
    this.style,
    this.textAlign = TextAlign.center,
    this.fontSize = 16.0,
    this.color = AppColors.white,
    this.fontFamily,
    this.fontWeight = FontWeight.normal,
    this.letterSpacing = 0.0,
    this.wordSpacing = 0.0,
    this.underline = false,
  });
  @override
  Widget build(BuildContext context) {
    final effectiveStyle =
        style?.copyWith(
          decoration: underline ? TextDecoration.underline : null,
          decorationColor: style?.color,
        ) ??
        AppTextStyles.bodyText16.copyWith(
          color: color,
          fontSize: fontSize,
          fontFamily: fontFamily,
          fontWeight: fontWeight,
          letterSpacing: letterSpacing,
          wordSpacing: wordSpacing,
          decoration: underline ? TextDecoration.underline : null,
          decorationColor: color,
        );

    return Text(label, textAlign: textAlign, style: effectiveStyle);
  }
}
