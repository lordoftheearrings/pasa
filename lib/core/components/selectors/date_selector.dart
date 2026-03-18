import 'package:pasa/core/components/text/app_text.dart';
import 'package:pasa/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class DateSelector extends StatelessWidget {
  final String label;
  final ValueChanged<DateTime>? onDateSelected;
  final DateTime? selectedDate;

  const DateSelector({
    super.key,
    required this.label,
    required this.onDateSelected,
    this.selectedDate,
  });

  Future<void> _pickDate(BuildContext context) async {
    DateTime now = DateTime.now();
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime(now.year, now.month, now.day),
      firstDate: DateTime(1960),
      lastDate: DateTime(now.year, now.month, now.day),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppColors.primary,
              onPrimary: AppColors.white,
              onSurface: AppColors.secondary,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: AppColors.primary),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      onDateSelected?.call(picked);
    }
  }

  static bool isUnderage(DateTime dob) {
    final today = DateTime.now();
    final age =
        today.year -
        dob.year -
        ((today.month < dob.month ||
                (today.month == dob.month && today.day < dob.day))
            ? 1
            : 0);
    return age < 18;
  }

  @override
  Widget build(BuildContext context) {
    final displayDate = selectedDate ?? DateTime.now();
    return GestureDetector(
      onTap: () => _pickDate(context),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.hint, width: 1),
          borderRadius: BorderRadius.circular(10),
          color: AppColors.black,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText(
              label: selectedDate == null
                  ? label
                  : "${displayDate.year} - ${displayDate.month} - ${displayDate.day}",
              style: TextStyle(
                color: selectedDate == null ? AppColors.hint : AppColors.white,
              ),
            ),
            const Icon(Icons.calendar_today, color: AppColors.hint, size: 20),
          ],
        ),
      ),
    );
  }
}
