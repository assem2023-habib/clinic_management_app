import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';

class DrQuickActions extends StatelessWidget {
  final VoidCallback? onRegisterPatient;
  final VoidCallback? onAddAppointment;
  final VoidCallback? onManageSchedule;

  const DrQuickActions({
    super.key,
    this.onRegisterPatient,
    this.onAddAppointment,
    this.onManageSchedule,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppStrings.daQuickActions,
          style: TextStyle(fontSize: AppSpacing.titleMedium, fontWeight: FontWeight.w600, color: colors.textPrimary)),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.md,
          children: [
            _buildActionButton(context, Icons.person_add_rounded, AppStrings.daRegisterPatient,
                colors.primaryDark, Colors.white, onRegisterPatient),
            _buildActionButton(context, Icons.event_note_rounded, AppStrings.daAddAppointment,
                colors.cardBg.withValues(alpha: 0.5), colors.textPrimary, onAddAppointment,
                borderColor: colors.divider.withValues(alpha: 0.2)),
            _buildActionButton(context, Icons.edit_calendar_rounded, AppStrings.daManageSchedule,
                colors.cardBg.withValues(alpha: 0.5), colors.textPrimary, onManageSchedule,
                borderColor: colors.divider.withValues(alpha: 0.2)),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    IconData icon,
    String label,
    Color bgColor,
    Color textColor,
    VoidCallback? onPressed, {
    Color? borderColor,
  }) {
    return SizedBox(
      height: 48,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: AppSpacing.iconSmall),
        label: Text(label, style: TextStyle(fontSize: AppSpacing.caption, fontWeight: FontWeight.w600)),
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: textColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
            side: borderColor != null ? BorderSide(color: borderColor) : BorderSide.none,
          ),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        ),
      ),
    );
  }
}
