import 'package:flutter/material.dart';
import 'package:pasa/core/constants/app_colors.dart';
import 'package:pasa/core/constants/app_fonts.dart';

class AppTextStyles {
  static const String _baseFont = AppFonts.primary;

  static const double sizeHeading1 = 32;
  static const double sizeHeading2 = 24;
  static const double sizeHeading3 = 20;
  static const double sizeBody16 = 16;
  static const double sizeBody14 = 14;

  static const FontWeight weightBold = FontWeight.bold;
  static const FontWeight weightSemiBold = FontWeight.w600;
  static const FontWeight weightRegular = FontWeight.w500;
  static const FontWeight weightSmall = FontWeight.w400;

  static const TextStyle heading1 = TextStyle(
    fontFamily: _baseFont,
    fontSize: sizeHeading1,
    fontWeight: weightBold,
    color: AppColors.white,
  );
  static const TextStyle heading2 = TextStyle(
    fontFamily: _baseFont,
    fontSize: sizeHeading2,
    fontWeight: weightBold,
    color: AppColors.white,
  );
  static const TextStyle heading3 = TextStyle(
    fontFamily: _baseFont,
    fontSize: sizeHeading3,
    fontWeight: weightBold,
    color: AppColors.white,
  );

  static const TextStyle bodyText16 = TextStyle(
    fontFamily: _baseFont,
    fontSize: sizeBody16,
    fontWeight: weightRegular,
    color: AppColors.white,
  );
  static const TextStyle bodyText14 = TextStyle(
    fontFamily: _baseFont,
    fontSize: sizeBody14,
    fontWeight: weightRegular,
    color: AppColors.white,
  );
  static const TextStyle bodyTextSemiBold = TextStyle(
    fontFamily: _baseFont,
    fontSize: sizeBody16,
    fontWeight: weightSemiBold,
    color: AppColors.white,
  );

  static const TextStyle primaryColorText16 = TextStyle(
    fontFamily: _baseFont,
    fontSize: sizeBody16,
    fontWeight: weightRegular,
    color: AppColors.primary,
  );

  static const TextStyle primaryColorText14 = TextStyle(
    fontFamily: _baseFont,
    fontSize: sizeBody14,
    fontWeight: weightRegular,
    color: AppColors.primary,
  );

  static const TextStyle secondaryColorText = TextStyle(
    fontFamily: _baseFont,
    fontSize: sizeBody16,
    fontWeight: weightRegular,
    color: AppColors.secondary,
  );

  static const TextStyle tertiaryColorText = TextStyle(
    fontFamily: _baseFont,
    fontSize: sizeBody16,
    fontWeight: weightRegular,
    color: AppColors.tertiary,
  );

  static const TextStyle tertiaryColorTextBold = TextStyle(
    fontFamily: _baseFont,
    fontSize: sizeBody16,
    fontWeight: weightBold,
    color: AppColors.tertiary,
  );

  static const TextStyle greyedOutText = TextStyle(
    fontFamily: _baseFont,
    fontSize: sizeBody14,
    fontWeight: weightSmall,
    color: AppColors.hint,
  );

  static const TextStyle successText = TextStyle(
    fontFamily: _baseFont,
    fontSize: sizeBody14,
    fontWeight: weightSmall,
    color: AppColors.success,
  );

  static const TextStyle errorText = TextStyle(
    fontFamily: _baseFont,
    fontSize: sizeBody14,
    fontWeight: weightSmall,
    color: AppColors.error,
  );

  static const TextStyle buttonText = TextStyle(
    fontFamily: _baseFont,
    fontSize: sizeBody16,
    fontWeight: weightRegular,
    color: AppColors.black,
  );

  static const TextStyle outlinedbuttonText = TextStyle(
    fontFamily: _baseFont,
    fontSize: sizeBody16,
    fontWeight: weightRegular,
    color: AppColors.white,
    letterSpacing: sizeBody16 * 0.06,
  );
  static const TextStyle hyperlinkText = TextStyle(
    fontFamily: _baseFont,
    fontSize: sizeBody16,
    fontWeight: weightRegular,
    color: AppColors.link,
    decoration: TextDecoration.underline,
    decorationColor: AppColors.link,
  );
}
