import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';

class DrQueueItem extends StatelessWidget {
  final int queueNumber;
  final String patientName;
  final String doctorName;
  final String checkInTime;
  final bool isEmergency;
  final VoidCallback? onTap;

  const DrQueueItem({
    super.key,
    required this.queueNumber,
    required this.patientName,
    required this.doctorName,
    required this.checkInTime,
    this.isEmergency = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    final bgColor = isEmergency ? colors.error.withValues(alpha: 0.08) : Colors.transparent;
    final numberColor = isEmergency ? colors.error : colors.primary;
    final numberBg = isEmergency ? colors.error.withValues(alpha: 0.15) : colors.primary.withValues(alpha: 0.1);
    final timeColor = isEmergency ? colors.error : colors.textSecondary;

    return Material(
      color: bgColor,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm + 2),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: numberBg,
                ),
                child: Center(
                  child: Text('#$queueNumber',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: numberColor)),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(patientName,
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: colors.textPrimary)),
                    const SizedBox(height: 2),
                    Text(doctorName,
                      style: TextStyle(fontSize: 12, color: colors.textLight)),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(AppStrings.daCheckInTime,
                    style: TextStyle(fontSize: 11, color: colors.textLight)),
                  const SizedBox(height: 2),
                  Text(checkInTime,
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: timeColor)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
