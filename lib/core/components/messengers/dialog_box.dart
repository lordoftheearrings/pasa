import 'package:pasa/core/components/buttons/app_button.dart';
import 'package:pasa/core/components/text/app_text.dart';
import 'package:pasa/core/constants/app_colors.dart';
import 'package:pasa/core/constants/app_textstyles.dart';
import 'package:flutter/material.dart';

class AppDialogBox extends StatelessWidget {
  final String title;
  final String content;
  final String confirmText;
  final String cancelText;

  const AppDialogBox({
    super.key,
    required this.title,
    required this.content,
    this.confirmText = 'Yes',
    this.cancelText = 'No',
  });

  static Future<bool?> show(
    BuildContext context, {
    required String title,
    required String content,
    String confirmText = 'Yes',
    String cancelText = 'No',
  }) {
    return showDialog<bool>(
      barrierDismissible: false,
      context: context,
      builder: (dialogContext) => AppDialogBox(
        title: title,
        content: content,
        confirmText: confirmText,
        cancelText: cancelText,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 20.0),
      backgroundColor: AppColors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppText(label: title, style: AppTextStyles.heading3),
            const SizedBox(height: 12.0),
            AppText(label: content, style: AppTextStyles.bodyText16),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: AppButton(
                    label: cancelText,
                    onPressed: () => Navigator.of(context).pop(false),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: AppButton(
                    label: confirmText,
                    onPressed: () => Navigator.of(context).pop(true),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
