import 'package:flutter/material.dart';
import 'package:pasa/core/constants/app_colors.dart';

class AppTextStyles {

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
    fontSize: sizeHeading1,
    fontWeight: weightBold,
    color: AppColors.white,
  );
  static const TextStyle heading2 = TextStyle(
    fontSize: sizeHeading2,
    fontWeight: weightBold,
    color: AppColors.white,
  );
  static const TextStyle heading3 = TextStyle(
    fontSize: sizeHeading3,
    fontWeight: weightBold,
    color: AppColors.white,
  );

  static const TextStyle bodyText16 = TextStyle(
    //
    fontSize: sizeBody16,
    fontWeight: weightRegular,
    color: AppColors.white,
  );
  static const TextStyle bodyText14 = TextStyle(
    fontSize: sizeBody14,
    fontWeight: weightRegular,
    color: AppColors.white,
  );
  static const TextStyle bodyTextSemiBold = TextStyle(
    fontSize: sizeBody16,
    fontWeight: weightSemiBold,
    color: AppColors.white,
  );

  static const TextStyle primaryColorText16 = TextStyle(
    fontSize: sizeBody16,
    fontWeight: weightRegular,
    color: AppColors.primary,
  );

  static const TextStyle primaryColorText14 = TextStyle(
    fontSize: sizeBody14,
    fontWeight: weightRegular,
    color: AppColors.primary,
  );

  static const TextStyle secondaryColorText = TextStyle(
    fontSize: sizeBody16,
    fontWeight: weightRegular,
    color: AppColors.secondary,
  );

  static const TextStyle tertiaryColorText = TextStyle(
    fontSize: sizeBody16,
    fontWeight: weightRegular,
    color: AppColors.tertiary,
  );

  static const TextStyle tertiaryColorTextBold = TextStyle(
    fontSize: sizeBody16,
    fontWeight: weightBold,
    color: AppColors.tertiary,
  );

  static const TextStyle greyedOutText = TextStyle(
    fontSize: sizeBody14,
    fontWeight: weightSmall,
    color: AppColors.hint,
  );

  static const TextStyle successText = TextStyle(
    fontSize: sizeBody14,
    fontWeight: weightSmall,
    color: AppColors.success,
  );

  static const TextStyle errorText = TextStyle(
    fontSize: sizeBody14,
    fontWeight: weightSmall,
    color: AppColors.error,
  );

  static const TextStyle buttonText = TextStyle(
    fontSize: sizeBody16,
    fontWeight: weightRegular,
    color: AppColors.black,
  );

  static const TextStyle outlinedbuttonText = TextStyle(
    fontSize: sizeBody16,
    fontWeight: weightRegular,
    color: AppColors.white,
    letterSpacing: sizeBody16 * 0.06,
  );
  static const TextStyle hyperlinkText = TextStyle(
    fontSize: sizeBody16,
    fontWeight: weightRegular,
    color: AppColors.link,
    decoration: TextDecoration.underline,
    decorationColor: AppColors.link,
  );
}
