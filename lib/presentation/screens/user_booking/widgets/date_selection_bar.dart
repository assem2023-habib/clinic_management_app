import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';

class DateSelectionBar extends StatelessWidget {
  final List<DateTime> dates;
  final DateTime selectedDate;
  final ValueChanged<DateTime> onSelectDate;
  final VoidCallback? onCalendarTap;

  const DateSelectionBar({
    super.key,
    required this.dates,
    required this.selectedDate,
    required this.onSelectDate,
    this.onCalendarTap,
  });

  static final _dayNames = [AppStrings.dayMonday, AppStrings.dayTuesday, AppStrings.dayWednesday, AppStrings.dayThursday, AppStrings.dayFriday, AppStrings.daySaturday, AppStrings.daySunday];

  String _dayName(DateTime date) => _dayNames[date.weekday - 1];

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${_monthName(selectedDate.month)}، ${selectedDate.year}',
              style: TextStyle(
                fontSize: AppSpacing.titleError - AppSpacing.xxs,
                fontWeight: FontWeight.w700,
                color: colors.textPrimary,
              ),
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(AppSpacing.lg),
                onTap: onCalendarTap,
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: colors.cardBg,
                    borderRadius: BorderRadius.circular(AppSpacing.lg),
                    border: Border.all(color: colors.divider.withValues(alpha: 0.3)),
                  ),
                  child: Icon(Icons.calendar_month_rounded, color: colors.primary, size: 22),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        SizedBox(
          height: 96,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: dates.length,
            separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
            itemBuilder: (context, index) {
              final date = dates[index];
              final isActive = _isSameDay(date, selectedDate);

              return GestureDetector(
                onTap: () => onSelectDate(date),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 60,
                  decoration: BoxDecoration(
                    color: isActive ? colors.primaryDark : colors.cardBg,
                    borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                    border: Border.all(
                      color: isActive ? colors.primary : colors.divider.withValues(alpha: 0.2),
                    ),
                    boxShadow: isActive
                        ? [BoxShadow(color: colors.primary.withValues(alpha: 0.2), blurRadius: 12)]
                        : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _dayName(date),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: isActive ? colors.textLight : colors.textLight,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        date.day.toString(),
                        style: TextStyle(
                          fontSize: AppSpacing.titleError - AppSpacing.xxs,
                          fontWeight: FontWeight.w700,
                          color: isActive ? Colors.white : colors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  String _monthName(int month) {
    final months = [
      AppStrings.monthJan, AppStrings.monthFeb, AppStrings.monthMar, AppStrings.monthApr, AppStrings.monthMay, AppStrings.monthJun,
      AppStrings.monthJul, AppStrings.monthAug, AppStrings.monthSep, AppStrings.monthOct, AppStrings.monthNov, AppStrings.monthDec
    ];
    return months[month - 1];
  }
}
