import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/domain/entities/doctor_entity.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';

class ProfileQualificationsSection extends StatelessWidget {
  final DoctorEntity doctor;

  const ProfileQualificationsSection({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppStrings.qualifications, style: TextStyle(fontSize: AppSpacing.titleMedium, fontWeight: FontWeight.w600, color: colors.textPrimary)),
            const SizedBox(height: AppSpacing.sm + AppSpacing.xs),
            ...(doctor.qualifications.isNotEmpty
                ? doctor.qualifications
                : doctor.education != null
                    ? [doctor.education!]
                    : []).map((qual) => Container(
              margin: const EdgeInsets.only(bottom: AppSpacing.sm),
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: colors.cardBg,
                borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
                border: Border.all(color: colors.divider.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: colors.secondary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppSpacing.sm),
                    ),
                    child: Icon(Icons.school_rounded, color: colors.secondary, size: AppSpacing.iconSmall),
                  ),
                  const SizedBox(width: AppSpacing.sm + AppSpacing.xs),
                  Expanded(child: Text(qual, style: TextStyle(fontSize: AppSpacing.bodyMedium, color: colors.textPrimary))),
                ],
              ),
            )),
          ],
        ),
      ],
    );
  }
}

