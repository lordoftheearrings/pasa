import 'package:pasa/core/components/text/app_text.dart';
import 'package:pasa/core/constants/app_colors.dart';
import 'package:pasa/core/constants/app_textstyles.dart';
import 'package:pasa/core/enums/gender.dart';
import 'package:flutter/material.dart';

class GenderSelection extends StatelessWidget {
  final Gender? selected;
  final ValueChanged<Gender?>? onChanged;

  const GenderSelection({super.key, this.onChanged, this.selected});

  @override
  Widget build(BuildContext context) {
    return RadioGroup<Gender>(
      groupValue: selected,
      onChanged: (gender) => onChanged?.call(gender),
      child: Column(
        children: Gender.values.map((gender) {
          return InkWell(
            onTap: () => onChanged?.call(gender),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(
                  label: gender == Gender.male
                      ? 'Male'
                      : gender == Gender.female
                      ? 'Female'
                      : 'Rather Not Say',
                  style: AppTextStyles.bodyText16,
                ),
                Radio<Gender>(
                  value: gender,
                  fillColor: WidgetStatePropertyAll(AppColors.success),
                  side: BorderSide(color: AppColors.white, width: 1.5),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
