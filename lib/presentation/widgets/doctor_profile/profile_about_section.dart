import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/domain/entities/doctor_entity.dart';

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
            Text(AppStrings.aboutDoctor, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: colors.textPrimary)),
            if (isEditable)
              IconButton(
                icon: Icon(Icons.edit_rounded, size: 20, color: colors.primary),
                onPressed: onEdit,
              ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colors.cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colors.divider.withValues(alpha: 0.2)),
          ),
          child: Text(
            doctor.bio ?? AppStrings.noInfoAvailable,
            style: TextStyle(fontSize: 14, color: colors.textSecondary, height: 1.6),
          ),
        ),
      ],
    );
  }
}
