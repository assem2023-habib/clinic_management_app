import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';

class RhCalendarBar extends StatelessWidget {
  final List<DateTime> dates;
  final DateTime selectedDate;
  final ValueChanged<DateTime> onSelectDate;

  const RhCalendarBar({
    super.key,
    required this.dates,
    required this.selectedDate,
    required this.onSelectDate,
  });

  static const _dayNamesEn = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return SizedBox(
      height: 88,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: dates.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) {
          final date = dates[index];
          final isActive = date.day == selectedDate.day &&
              date.month == selectedDate.month &&
              date.year == selectedDate.year;

          return GestureDetector(
            onTap: () => onSelectDate(date),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 56,
              decoration: BoxDecoration(
                color: isActive ? colors.surface : colors.cardBg.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                border: Border.all(
                  color: isActive ? colors.secondary.withValues(alpha: 0.5) : colors.divider.withValues(alpha: 0.15),
                ),
                boxShadow: isActive ? [BoxShadow(color: colors.secondary.withValues(alpha: 0.15), blurRadius: 12)] : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _dayNamesEn[date.weekday - 1],
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: isActive ? colors.secondary : colors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    date.day.toString(),
                    style: TextStyle(
                      fontSize: AppSpacing.titleMedium,
                      fontWeight: FontWeight.w700,
                      color: isActive ? colors.secondary : colors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
