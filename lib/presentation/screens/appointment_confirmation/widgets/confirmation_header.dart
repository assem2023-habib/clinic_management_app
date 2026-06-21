import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/domain/entities/user_role.dart';

class ConfirmationHeader extends StatelessWidget {
  final UserRole role;

  const ConfirmationHeader({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    final title = role == UserRole.patient
        ? AppStrings.confirmationPatientTitle
        : AppStrings.confirmationDoctorTitle;
    final subtitle = role == UserRole.patient
        ? AppStrings.confirmationPatientSubtitle
        : AppStrings.confirmationDoctorSubtitle;

    return Column(
      children: [
        Container(
          width: AppSpacing.confirmationIconSize,
          height: AppSpacing.confirmationIconSize,
          decoration: BoxDecoration(
            color: colors.warning,
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: colors.warning.withValues(alpha: 0.3), blurRadius: AppSpacing.xxl)],
          ),
          child: Icon(Icons.hourglass_top_rounded, color: Colors.white, size: AppSpacing.xxl),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          title,
          style: TextStyle(
            fontSize: AppSpacing.titleLarge,
            fontWeight: FontWeight.w700,
            color: colors.primary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: AppSpacing.bodyMedium,
            color: colors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
