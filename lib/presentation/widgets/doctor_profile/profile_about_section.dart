import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/domain/entities/doctor_entity.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';

class ProfileAboutSection extends StatelessWidget {
  final DoctorEntity doctor;
  final bool isEditable;
  final VoidCallback? onEdit;

  const ProfileAboutSection({
    super.key,
    required this.doctor,
    this.isEditable = false,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(AppStrings.aboutDoctor, style: TextStyle(fontSize: AppSpacing.titleMedium, fontWeight: FontWeight.w600, color: colors.textPrimary)),
            if (isEditable)
              IconButton(
                icon: Icon(Icons.edit_rounded, size: AppSpacing.iconSmall, color: colors.primary),
                onPressed: onEdit,
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm + AppSpacing.xs),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: colors.cardBg,
            borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
            border: Border.all(color: colors.divider.withValues(alpha: 0.2)),
          ),
          child: Text(
            doctor.bio ?? AppStrings.noInfoAvailable,
            style: TextStyle(fontSize: AppSpacing.bodyMedium, color: colors.textSecondary, height: 1.6),
          ),
        ),
      ],
    );
  }
}

