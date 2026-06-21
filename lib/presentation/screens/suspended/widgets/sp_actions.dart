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
    return Column(
      children: [
        SizedBox(
          width: 340,
          height: AppSpacing.buttonHeight,
          child: ElevatedButton.icon(
            onPressed: onContactSupport,
            icon: const Icon(Icons.support_agent_rounded, size: 22),
            label: const Text(AppStrings.spContactSupport),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
              foregroundColor: const Color(0xFF00422B),
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
            icon: const Icon(Icons.logout_rounded, size: 22),
            label: const Text(AppStrings.spLogout),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF4EDEA3),
              side: BorderSide(
                color: const Color(0xFF4EDEA3).withValues(alpha: 0.3),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        const Text(
          AppStrings.spFooter,
          style: TextStyle(
            fontSize: AppSpacing.bodySmall,
            fontWeight: FontWeight.w600,
            color: Color(0xFFBBCABF),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
