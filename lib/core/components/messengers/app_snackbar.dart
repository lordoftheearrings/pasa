import 'package:pasa/core/components/text/app_text.dart';
import 'package:pasa/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:pasa/core/enums/snackbar_type.dart';

class AppSnackbar {
  static void showSuccess(BuildContext context, String message) =>
      show(context, message, SnackBarType.success);
  static void showError(BuildContext context, String message) =>
      show(context, message, SnackBarType.error);
  static void showWarning(BuildContext context, String message) =>
      show(context, message, SnackBarType.warning);
  static void showInfo(BuildContext context, String message) =>
      show(context, message, SnackBarType.info);

  static void show(BuildContext context, String message, SnackBarType type) {
    if (!context.mounted) return;
    final config = snackconfig(type);
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final bottomPadding = MediaQuery.of(context).viewPadding.bottom + 32;

    scaffoldMessenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: config.background,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          duration: const Duration(milliseconds: 1300),
          margin: EdgeInsets.fromLTRB(16, 0, 16, bottomPadding),
          content: Row(
            children: [
              Icon(config.icon, color: config.iconColor, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: AppText(
                  label: message,
                  color: config.textColor,
                  fontSize: 16,
                ),
              ),
              GestureDetector(
                onTap: () {
                  scaffoldMessenger.hideCurrentSnackBar();
                },
                child: Icon(
                  Icons.cancel_outlined,
                  color: config.iconColor,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      );
  }

  static ({Color background, Color textColor, Color iconColor, IconData icon})
  snackconfig(SnackBarType type) {
    switch (type) {
      case SnackBarType.success:
        return (
          background: AppColors.success,
          textColor: AppColors.black,
          iconColor: AppColors.black,
          icon: Icons.check_circle,
        );
      case SnackBarType.error:
        return (
          background: AppColors.error,
          textColor: AppColors.black,
          iconColor: AppColors.black,
          icon: Icons.error,
        );
      case SnackBarType.warning:
        return (
          background: AppColors.warning,
          textColor: AppColors.black,
          iconColor: AppColors.black,
          icon: Icons.warning,
        );
      case SnackBarType.info:
        return (
          background: AppColors.info,
          textColor: AppColors.black,
          iconColor: AppColors.black,
          icon: Icons.info,
        );
    }
  }
}
