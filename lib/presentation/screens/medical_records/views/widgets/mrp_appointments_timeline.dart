import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';

class MrpTimelineItem extends StatelessWidget {
  final bool isPrimary;
  final String date;
  final String doctorName;
  final String specialty;

  const MrpTimelineItem({
    super.key,
    required this.isPrimary,
    required this.date,
    required this.doctorName,
    required this.specialty,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isPrimary
                      ? colors.primary
                      : colors.textLight,
                  border: Border.all(
                    color: colors.scaffoldBg,
                    width: 4,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  width: 1,
                  color: colors.textSecondary.withValues(alpha: 0.3),
                ),
              ),
            ],
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: AppSpacing.md),
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: colors.surfaceDark.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
                border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    date,
                    style: TextStyle(
                      fontSize: AppSpacing.bodySmall,
                      fontWeight: FontWeight.w600,
                      color: colors.primary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            doctorName,
                            style: TextStyle(
                              fontSize: AppSpacing.bodyMedium,
                              fontWeight: FontWeight.w600,
                              color: colors.textPrimary,
                            ),
                          ),
                          Text(
                            specialty,
                            style: TextStyle(
                              fontSize: AppSpacing.bodySmall,
                              fontWeight: FontWeight.w500,
                              color: colors.divider,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: colors.surfaceDark,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          AppStrings.mrVisitDone,
                          style: TextStyle(
                            fontSize: AppSpacing.bodySmall,
                            fontWeight: FontWeight.w500,
                            color: colors.divider,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

