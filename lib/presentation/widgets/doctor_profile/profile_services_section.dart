import 'package:clinic_management_app/core/constants/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/domain/entities/doctor_entity.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';

class ProfileServicesSection extends StatelessWidget {
  final DoctorEntity doctor;
  final bool isEditable;
  final VoidCallback? onEdit;

  const ProfileServicesSection({
    super.key,
    required this.doctor,
    this.isEditable = false,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    if (doctor.services.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(AppStrings.services, style: TextStyle(fontSize: AppSpacing.titleMedium, fontWeight: FontWeight.w600, color: colors.textPrimary)),
            if (isEditable)
              IconButton(
                icon: Icon(AppIcons.edit, size: AppSpacing.iconSmall, color: colors.primary),
                onPressed: onEdit,
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm + AppSpacing.xs),
        ...doctor.services.map((service) => Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
                  color: colors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.sm),
                ),
                child: Icon(AppIcons.medicalServices, color: colors.primary, size: AppSpacing.iconSmall),
              ),
              const SizedBox(width: AppSpacing.sm + AppSpacing.xs),
              Expanded(child: Text(service, style: TextStyle(fontSize: AppSpacing.bodyMedium, color: colors.textPrimary))),
              Icon(AppIcons.chevronLeft, color: colors.textLight, size: AppSpacing.iconSmall),
            ],
          ),
        )),
      ],
    );
  }
}

