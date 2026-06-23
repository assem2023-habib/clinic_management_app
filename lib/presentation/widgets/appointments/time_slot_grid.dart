import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';

class TimeSlotGrid extends StatefulWidget {
  const TimeSlotGrid({super.key});

  @override
  State<TimeSlotGrid> createState() => _TimeSlotGridState();
}

class _TimeSlotGridState extends State<TimeSlotGrid> {
  String? _selectedTime;

  static const _slots = [
    '08:00 ص', '09:30 ص', '10:00 ص',
    '11:30 ص', '01:00 م', '03:00 م',
    '04:15 م', '05:30 م', '06:00 م',
  ];

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Container(
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 0, 20, AppSpacing.xl),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Center(child: Container(
          margin: const EdgeInsets.symmetric(vertical: 14),
          width: 44, height: 5,
          decoration: BoxDecoration(
            color: c.textLight.withValues(alpha: 0.28),
            borderRadius: BorderRadius.circular(999),
          ),
        )),
        Text('اختر وقتاً جديداً', style: TextStyle(fontSize: AppSpacing.titleMedium, fontWeight: FontWeight.w700, color: c.textPrimary)),
        const SizedBox(height: 20),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 2.2,
          children: _slots.map((slot) {
            final selected = _selectedTime == slot;
            return GestureDetector(
              onTap: () => setState(() => _selectedTime = slot),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: selected ? c.primaryDark : c.cardBg,
                  borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
                  border: selected ? null : Border.all(color: Colors.white.withValues(alpha: 0.06)),
                ),
                alignment: Alignment.center,
                child: Text(slot,
                  style: TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w600,
                    color: selected ? c.primaryLight : c.textSecondary,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
        SizedBox(width: double.infinity,
          child: ElevatedButton(
            onPressed: _selectedTime == null ? null : () => Navigator.pop(context, _selectedTime),
            style: ElevatedButton.styleFrom(
              backgroundColor: c.primaryDark,
              disabledBackgroundColor: c.cardBg,
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.md - AppSpacing.xxs)),
            ),
            child: Text(
              'تأكيد الموعد الجديد',
              style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.w700,
                color: _selectedTime != null ? c.primaryLight : c.textSecondary.withValues(alpha: 0.5),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
