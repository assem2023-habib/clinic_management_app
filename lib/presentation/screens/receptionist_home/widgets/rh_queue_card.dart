import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/domain/entities/appointment_entity.dart';

class RhQueueCard extends StatelessWidget {
  final AppointmentEntity appointment;
  final int index;

  const RhQueueCard({
    super.key,
    required this.appointment,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    final (Color accentColor, String statusLabel, Color statusBg, Color statusTextColor) = switch (appointment.status) {
      AppointmentStatus.inProgress => (colors.secondary, AppStrings.rhWithDoctor, colors.secondary.withValues(alpha: 0.15), colors.secondary),
      AppointmentStatus.scheduled => (colors.warning, AppStrings.rhWaiting, colors.warning.withValues(alpha: 0.15), colors.warning),
      _ => (colors.textLight, AppStrings.rhCheckingIn, colors.divider.withValues(alpha: 0.15), colors.textLight),
    };

    final double opacity = appointment.status == AppointmentStatus.cancelled ? 0.6 : 1.0;

    return Opacity(
      opacity: opacity,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: colors.cardBg.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          border: Border.all(color: colors.divider.withValues(alpha: 0.08)),
        ),
        child: Row(
          children: [
            Container(width: 4, height: AppSpacing.xxl, decoration: BoxDecoration(
              color: accentColor,
              borderRadius: BorderRadius.circular(2),
            )),
            const SizedBox(width: AppSpacing.md),
            CircleAvatar(
              radius: 22,
              backgroundColor: colors.divider.withValues(alpha: 0.15),
              child: Text(
                appointment.patientName.isNotEmpty ? appointment.patientName[0] : '?',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: colors.primary),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        appointment.patientName,
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: colors.textPrimary),
                      ),
                      Text(
                        appointment.timeSlot,
                        style: TextStyle(fontSize: 12, color: accentColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${AppStrings.rhWithDoctorSub}${appointment.doctorName}',
                    style: TextStyle(fontSize: 12, color: colors.textSecondary),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
              decoration: BoxDecoration(
                color: statusBg,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                statusLabel,
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: statusTextColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
