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
                  const SizedBox(height: 16),
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
                      const SizedBox(width: 8),
                      Icon(Icons.verified_rounded, color: colors.secondary, size: 22),
                    ],
                  ),
                  const SizedBox(height: 4),
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
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.star_rounded, color: Colors.amber, size: 20),
                      const SizedBox(width: 4),
                      Text(
                        doctor.rating.toString(),
                        style: TextStyle(fontSize: AppSpacing.bodyMedium, fontWeight: FontWeight.w600, color: colors.textPrimary),
                      ),
                      Text(
                        ' (${doctor.reviewsCount} ${AppStrings.rating})',
                        style: TextStyle(fontSize: 13, color: colors.textLight),
                      ),
                      const SizedBox(width: 12),
                      Icon(Icons.location_on_rounded, size: 18, color: colors.textLight),
                      const SizedBox(width: 2),
                      Flexible(
                        child: Text(
                          doctor.clinicAddress ?? 'الرياض',
                          style: TextStyle(fontSize: 13, color: colors.textLight),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  if (doctor.languages.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      children: doctor.languages.map((lang) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: colors.chipBg,
                          borderRadius: BorderRadius.circular(20),
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

