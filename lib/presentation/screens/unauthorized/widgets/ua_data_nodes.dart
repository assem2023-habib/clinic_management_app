import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/core/constants/app_icons.dart';

class UaDataNodes extends StatelessWidget {
  const UaDataNodes({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Wrap(
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.sm + AppSpacing.xs,
      alignment: WrapAlignment.center,
      children: [
        _buildChip(colors, AppIcons.lockOpen, AppStrings.uaEncryption),
        _buildChip(colors, AppIcons.verifiedUser, AppStrings.uaDataProtection),
        _buildChip(colors, AppIcons.security, AppStrings.uaSecureProtocol),
      ],
    );
  }

  Widget _buildChip(AppColorSet colors, IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm + AppSpacing.xs, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: colors.mint),
          const SizedBox(width: AppSpacing.bulletSize),
          Text(
            label,
            style: TextStyle(
              fontSize: AppSpacing.bodySmall,
              fontWeight: FontWeight.w600,
              color: colors.sage,
            ),
          ),
        ],
      ),
    );
  }
}
