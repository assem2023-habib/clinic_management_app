import 'package:clinic_management_app/core/constants/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';

class DatePickerField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final DateTime? firstDate;
  final DateTime? lastDate;

  const DatePickerField({
    super.key,
    required this.controller,
    required this.label,
    this.firstDate,
    this.lastDate,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return TextFormField(
      controller: controller,
      readOnly: true,
      style: TextStyle(color: colors.textPrimary, fontSize: AppSpacing.bodyLarge),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: controller.text.isEmpty ? colors.textLight : colors.textSecondary),
        filled: true,
        fillColor: colors.cardBg,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppSpacing.buttonRadius)),
        suffixIcon: Icon(AppIcons.calendarMonth, color: colors.primaryLight, size: AppSpacing.iconMedium),
      ),
      onTap: () => _pickDate(context, colors),
    );
  }

  Future<void> _pickDate(BuildContext context, AppColorSet colors) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: controller.text.isEmpty
          ? now
          : DateFormat('yyyy-MM-dd').parse(controller.text),
      firstDate: firstDate ?? DateTime(1900),
      lastDate: lastDate ?? now,
      builder: (ctx, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            datePickerTheme: DatePickerThemeData(
              backgroundColor: colors.cardBg,
              headerBackgroundColor: colors.primary,
              headerForegroundColor: colors.surface,
              todayForegroundColor: WidgetStatePropertyAll(colors.primary),
              todayBackgroundColor: WidgetStatePropertyAll(colors.primary.withValues(alpha: 0.15)),
              dayForegroundColor: WidgetStatePropertyAll(colors.textPrimary),
              surfaceTintColor: colors.surface,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      controller.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }
}

