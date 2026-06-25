import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';
import 'package:clinic_management_app/core/constants/app_icons.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';

class SfActions extends StatelessWidget {
  final VoidCallback? onRetry;
  final VoidCallback? onBack;

  const SfActions({super.key, this.onRetry, this.onBack});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onRetry ?? () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.emerald,
                foregroundColor: colors.buttonBg,
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.buttonRadius)),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(AppIcons.refresh, size: AppSpacing.iconSmall),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    AppStrings.searchAgain,
                    style: TextStyle(fontFamily: 'Sora', fontSize: AppSpacing.bodyLarge, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm + AppSpacing.xs),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: onBack ?? () => Navigator.pop(context),
              child: Text(
                AppStrings.backToSearch,
                style: TextStyle(fontFamily: 'Sora', fontSize: AppSpacing.subtitle, fontWeight: FontWeight.w500, color: colors.textMuted),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
