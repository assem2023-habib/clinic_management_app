import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/domain/entities/doctor_entity.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';

class ProfileHeader extends StatelessWidget {
  final DoctorEntity doctor;

  const ProfileHeader({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: Hero(
            tag: 'doctor_hero_${doctor.id}',
            child: Material(
              color: Colors.transparent,
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 56,
                    backgroundColor: colors.primary.withValues(alpha: 0.15),
                    backgroundImage: doctor.imageUrl != null
                        ? NetworkImage(doctor.imageUrl!)
                        : null,
                    child: doctor.imageUrl == null
                        ? Icon(Icons.person_rounded, size: 48, color: colors.primary)
                        : null,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          doctor.name,
                          style: TextStyle(
                            fontSize: AppSpacing.titleError,
                            fontWeight: FontWeight.w700,
                            color: colors.textPrimary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Icon(Icons.verified_rounded, color: colors.secondary, size: AppSpacing.iconMedium),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    doctor.specialty,
                    style: TextStyle(
                      fontSize: AppSpacing.bodyMedium,
                      fontWeight: FontWeight.w600,
                      color: colors.primary,
                      letterSpacing: 0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.star_rounded, color: Colors.amber, size: AppSpacing.iconSmall),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        doctor.rating.toString(),
                        style: TextStyle(fontSize: AppSpacing.bodyMedium, fontWeight: FontWeight.w600, color: colors.textPrimary),
                      ),
                      Text(
                        ' (${doctor.reviewsCount} ${AppStrings.rating})',
                        style: TextStyle(fontSize: AppSpacing.caption, color: colors.textLight),
                      ),
                      const SizedBox(width: AppSpacing.sm + AppSpacing.xs),
                      Icon(Icons.location_on_rounded, size: 18, color: colors.textLight),
                      const SizedBox(width: AppSpacing.xxs),
                      Flexible(
                        child: Text(
                          doctor.clinicAddress ?? 'الرياض',
                          style: TextStyle(fontSize: AppSpacing.caption, color: colors.textLight),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  if (doctor.languages.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Wrap(
                      spacing: 6,
                      children: doctor.languages.map((lang) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.ten, vertical: AppSpacing.xs),
                        decoration: BoxDecoration(
                          color: colors.chipBg,
                          borderRadius: BorderRadius.circular(AppSpacing.lg - AppSpacing.xs),
                        ),
                        child: Text(lang, style: TextStyle(fontSize: AppSpacing.bodySmall, color: colors.chipText)),
                      )).toList(),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

