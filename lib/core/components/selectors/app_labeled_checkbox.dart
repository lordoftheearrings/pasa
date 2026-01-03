import 'package:pasa/core/components/text/app_text.dart';
import 'package:pasa/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class LabeledCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;
  final String label;

  const LabeledCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
          checkColor: AppColors.white,
          activeColor: Colors.transparent,
          side: WidgetStateBorderSide.resolveWith(
            (states) => const BorderSide(color: AppColors.white, width: 1.5),
          ),
        ),
        AppText(label: label, textAlign: TextAlign.start),
      ],
    );
  }
}
