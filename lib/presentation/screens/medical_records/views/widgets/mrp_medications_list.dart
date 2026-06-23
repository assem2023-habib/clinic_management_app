import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';

class MrpMedicationCard extends StatelessWidget {
  final IconData icon;
  final String name;
  final String dosage;

  const MrpMedicationCard({
    super.key,
    required this.icon,
    required this.name,
    required this.dosage,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: colors.surfaceDark.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors.accent.withValues(alpha: 0.2),
            ),
            child: Icon(icon, size: AppSpacing.iconSize, color: colors.secondary),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: AppSpacing.bodyMedium,
                    fontWeight: FontWeight.w600,
                    color: colors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  dosage,
                  style: TextStyle(
                    fontSize: AppSpacing.bodySmall,
                    fontWeight: FontWeight.w500,
                    color: colors.divider,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_left_rounded,
            size: AppSpacing.iconSize,
            color: colors.divider,
          ),
        ],
      ),
    );
  }
}

