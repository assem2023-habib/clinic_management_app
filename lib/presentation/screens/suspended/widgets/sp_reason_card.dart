import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';

class SpReasonCard extends StatelessWidget {
  const SpReasonCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: colors.cardBg.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.05),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.spReasonLabel,
            style: TextStyle(
              fontSize: AppSpacing.bodySmall,
              fontWeight: FontWeight.w600,
              color: colors.mint,
              letterSpacing: 0.05,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            AppStrings.spReasonValue,
            style: TextStyle(
              fontSize: AppSpacing.bodyLarge,
              color: colors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
