import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';

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
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).padding.bottom + 8,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            colors.background.withValues(alpha: 0.0),
            colors.background,
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
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : const Icon(Icons.event_available_rounded, size: 22),
            label: Text(
              isLoading ? 'جارٍ تأكيد الحجز...' : 'تأكيد الحجز',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.primary,
              foregroundColor: Colors.white,
              disabledBackgroundColor: colors.divider.withValues(alpha: 0.3),
              disabledForegroundColor: colors.textLight,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 0,
            ),
          ),
        ),
      ),
    );
  }
}
