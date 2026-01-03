import 'package:flutter/material.dart';
import 'package:pasa/core/components/text/app_text.dart';
import 'package:pasa/core/constants/app_colors.dart';
import 'package:pasa/core/constants/app_textstyles.dart';
import 'package:pasa/core/enums/snackbar_type.dart';

class AppBanner {
  static void showSuccess(
    BuildContext context,
    String message,
    IconData? leadingIcon,
    Duration? autoHideDuration,
  ) => show(
    context,
    message,
    SnackBarType.success,
    leadingIcon: leadingIcon,
    autoHideDuration: autoHideDuration,
  );

  static void showError(
    BuildContext context,
    String message,
    IconData? leadingIcon,
    Duration? autoHideDuration,
  ) => show(
    context,
    message,
    SnackBarType.error,
    leadingIcon: leadingIcon,
    autoHideDuration: autoHideDuration,
  );

  static void showWarning(
    BuildContext context,
    String message,
    IconData? leadingIcon,
    Duration? autoHideDuration,
  ) => show(
    context,
    message,
    SnackBarType.warning,
    leadingIcon: leadingIcon,
    autoHideDuration: autoHideDuration,
  );

  static void showInfo(
    BuildContext context,
    String message,
    IconData? leadingIcon,
    Duration? autoHideDuration,
  ) => show(
    context,
    message,
    SnackBarType.info,
    leadingIcon: leadingIcon,
    autoHideDuration: autoHideDuration,
  );

  static void show(
    BuildContext context,
    String message,
    SnackBarType type, {
    IconData? leadingIcon,
    Duration? autoHideDuration,
  }) {
    final config = bannerConfig(type);

    final messenger = ScaffoldMessenger.of(context);

    messenger.hideCurrentMaterialBanner();

    messenger.showMaterialBanner(
      MaterialBanner(
        backgroundColor: config.background,
        elevation: 0,
        padding: EdgeInsets.zero,
        minActionBarHeight: 20,
        leading: leadingIcon != null
            ? Icon(leadingIcon, color: config.iconColor, size: 20)
            : null,
        leadingPadding: const EdgeInsets.only(left: 20),
        content: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: AppText(
            key: ValueKey(message),
            label: message,
            style: AppTextStyles.buttonText.copyWith(color: config.textColor),
          ),
        ),
        actions: [
          GestureDetector(
            onTap: messenger.hideCurrentMaterialBanner,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 4.0,
              ),
              child: Icon(
                Icons.cancel_outlined,
                color: config.iconColor,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );

    if (autoHideDuration != null) {
      Future.delayed(autoHideDuration, () {
        if (messenger.mounted) messenger.hideCurrentMaterialBanner();
      });
    }
  }

  static ({Color background, Color textColor, Color iconColor, IconData icon})
  bannerConfig(SnackBarType type) {
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
