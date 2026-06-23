import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';

class RhQuickActions extends StatelessWidget {
  final VoidCallback? onNewAppointment;
  final VoidCallback? onRegisterPatient;
  final VoidCallback? onScanMedicalId;

  const RhQuickActions({
    super.key,
    this.onNewAppointment,
    this.onRegisterPatient,
    this.onScanMedicalId,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: onNewAppointment,
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.primaryDark,
              foregroundColor: colors.textPrimary,
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.md, horizontal: AppSpacing.md),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.cardRadius)),
              elevation: 0,
            ),
            child: Row(
              children: [
                Container(
                  width: AppSpacing.xxl,
                  height: AppSpacing.xxl,
                  decoration: BoxDecoration(
                    color: colors.primaryLight.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.person_add_rounded, color: colors.primaryLight, size: 26),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.rhNewAppointment,
                        style: TextStyle(fontSize: AppSpacing.titleMedium, fontWeight: FontWeight.w600, color: colors.textPrimary),
                      ),
                      Text(
                        AppStrings.rhBookSlot,
                        style: TextStyle(fontSize: AppSpacing.bodySmall, color: colors.textPrimary.withValues(alpha: 0.8)),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_rounded, color: colors.primaryLight),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: _buildSecondaryButton(
                context,
                Icons.how_to_reg_rounded,
                AppStrings.rhRegisterPatient,
                colors.secondary,
                onRegisterPatient,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _buildSecondaryButton(
                context,
                Icons.qr_code_scanner_rounded,
                AppStrings.rhScanMedicalId,
                colors.secondary,
                onScanMedicalId,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSecondaryButton(
    BuildContext context,
    IconData icon,
    String label,
    Color color,
    VoidCallback? onPressed,
  ) {
    final colors = AppColors.of(context);
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: colors.cardBg.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          border: Border.all(color: colors.divider.withValues(alpha: 0.08)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: AppSpacing.sm),
            Text(label, style: TextStyle(fontSize: AppSpacing.bodyMedium, fontWeight: FontWeight.w600, color: colors.textPrimary)),
          ],
        ),
      ),
    );
  }
}
