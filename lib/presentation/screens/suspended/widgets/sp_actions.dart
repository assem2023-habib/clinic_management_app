import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';

class SpActions extends StatelessWidget {
  final VoidCallback? onContactSupport;
  final VoidCallback? onLogout;

  const SpActions({
    super.key,
    this.onContactSupport,
    this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Column(
      children: [
        SizedBox(
          width: 340,
          height: AppSpacing.buttonHeight,
          child: ElevatedButton.icon(
            onPressed: onContactSupport,
            icon: const Icon(Icons.support_agent_rounded, size: AppSpacing.iconMedium),
            label:  Text(AppStrings.spContactSupport),
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.emerald,
              foregroundColor: colors.buttonTextDark,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
              ),
              elevation: 0,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          width: 340,
          height: AppSpacing.buttonHeight,
          child: OutlinedButton.icon(
            onPressed: onLogout ?? () => Navigator.of(context).pop(),
            icon: const Icon(Icons.logout_rounded, size: AppSpacing.iconMedium),
            label:  Text(AppStrings.spLogout),
            style: OutlinedButton.styleFrom(
              foregroundColor: colors.mint,
              side: BorderSide(
                color: colors.mint.withValues(alpha: 0.3),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          AppStrings.spFooter,
          style: TextStyle(
            fontSize: AppSpacing.bodySmall,
            fontWeight: FontWeight.w600,
            color: colors.textMuted,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
