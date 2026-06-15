import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';

class UfSecurityCard extends StatelessWidget {
  const UfSecurityCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colors.chipBg.withValues(alpha: 0.3),
            Colors.transparent,
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.primary.withValues(alpha: 0.2)),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -40,
            left: -40,
            child: Container(
              width: 128,
              height: 128,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.primary.withValues(alpha: 0.1),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.security_rounded, size: 32, color: colors.primary),
              const SizedBox(height: AppSpacing.sm),
              Text(
                AppStrings.ufSecurityTitle,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: colors.textPrimary),
              ),
              const SizedBox(height: 4),
              Text(
                AppStrings.ufSecurityMessage,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: colors.textLight, height: 1.5),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
