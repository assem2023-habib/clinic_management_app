import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_routes.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/domain/entities/user_role.dart';

class ConfirmationActions extends StatelessWidget {
  final UserRole role;
  final String doctorId;
  final VoidCallback? onAddToCalendar;

  const ConfirmationActions({
    super.key,
    required this.role,
    required this.doctorId,
    this.onAddToCalendar,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    final primaryLabel = switch (role) {
      UserRole.patient => AppStrings.goToMyAppointments,
      UserRole.doctor => AppStrings.viewMySchedule,
      _ => AppStrings.goToAppointmentManagement,
    };

    final primaryRoute = AppRoutes.appointments;

    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: AppSpacing.xxl,
            child: ElevatedButton.icon(
              onPressed: () => Navigator.pushNamed(context, primaryRoute),
              icon: const Icon(Icons.event_note_rounded, size: AppSpacing.iconSmall),
              label: Text(primaryLabel, style: const TextStyle(fontSize: AppSpacing.bodyMedium, fontWeight: FontWeight.w600)),
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.buttonRadius)),
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm + AppSpacing.xs),
        Expanded(
          child: SizedBox(
            height: AppSpacing.xxl,
            child: OutlinedButton.icon(
              onPressed: onAddToCalendar,
              icon: Icon(Icons.calendar_today_rounded, size: AppSpacing.iconSmall, color: colors.primary),
              label: Text(AppStrings.addToCalendar, style: TextStyle(fontSize: AppSpacing.bodyMedium, color: colors.primary)),
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.buttonRadius)),
                side: BorderSide(color: colors.primary.withValues(alpha: 0.3)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
