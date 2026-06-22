import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';

class ConfirmBookingBar extends StatelessWidget {
  final bool isEnabled;
  final bool isLoading;
  final VoidCallback? onConfirm;

  const ConfirmBookingBar({
    super.key,
    this.isEnabled = false,
    this.isLoading = false,
    this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Container(
      padding: EdgeInsets.only(
        left: AppSpacing.md,
        right: AppSpacing.md,
        top: AppSpacing.md,
        bottom: MediaQuery.of(context).padding.bottom + AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            colors.scaffoldBg.withValues(alpha: 0.0),
            colors.scaffoldBg,
          ],
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton.icon(
            onPressed: isEnabled && !isLoading ? onConfirm : null,
            icon: isLoading
                ? SizedBox(
                    width: AppSpacing.iconSmall,
                    height: AppSpacing.iconSmall,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : const Icon(Icons.event_available_rounded, size: 22),
            label: Text(
              isLoading ? AppStrings.bookingConfirming : AppStrings.bookingConfirm,
              style: const TextStyle(fontSize: AppSpacing.md, fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.primary,
              foregroundColor: Colors.white,
              disabledBackgroundColor: colors.divider.withValues(alpha: 0.3),
              disabledForegroundColor: colors.textLight,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.cardRadius)),
              elevation: 0,
            ),
          ),
        ),
      ),
    );
  }
}
