import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';
import 'package:clinic_management_app/domain/entities/doctor_entity.dart';

class DoctorBookingCard extends StatelessWidget {
  final DoctorEntity doctor;

  const DoctorBookingCard({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(color: colors.divider.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: AppSpacing.xl,
                backgroundColor: colors.primary.withValues(alpha: 0.15),
                backgroundImage: doctor.imageUrl != null
                    ? NetworkImage(doctor.imageUrl!)
                    : null,
                child: doctor.imageUrl == null
                    ? Icon(Icons.person_rounded, size: AppSpacing.xl, color: colors.primary)
                    : null,
              ),
              Positioned(
                bottom: 0,
                left: 0,
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: doctor.isAvailable ? colors.success : colors.textLight,
                    shape: BoxShape.circle,
                    border: Border.all(color: colors.cardBg, width: 2),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doctor.name,
                  style: TextStyle(
                    fontSize: AppSpacing.titleMedium,
                    fontWeight: FontWeight.w600,
                    color: colors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  doctor.specialty,
                  style: TextStyle(
                    fontSize: AppSpacing.bodyMedium,
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.verified_rounded, color: colors.primary, size: AppSpacing.lg),
        ],
      ),
    );
  }
}
