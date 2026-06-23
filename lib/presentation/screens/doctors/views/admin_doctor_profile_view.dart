import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/domain/entities/doctor_profile_entity.dart';
import 'package:clinic_management_app/presentation/widgets/doctor_profile/profile_header.dart';
import 'package:clinic_management_app/presentation/widgets/doctor_profile/profile_stats_grid.dart';
import 'package:clinic_management_app/presentation/widgets/doctor_profile/profile_about_section.dart';
import 'package:clinic_management_app/presentation/widgets/doctor_profile/profile_services_section.dart';
import 'package:clinic_management_app/presentation/widgets/doctor_profile/profile_schedule_section.dart';
import 'package:clinic_management_app/presentation/widgets/doctor_profile/profile_reviews_section.dart';

class AdminDoctorProfileView extends StatelessWidget {
  final DoctorProfileEntity profile;
  final VoidCallback? onToggleSlot;
  final VoidCallback? onEditProfile;
  final VoidCallback? onDeleteDoctor;

  const AdminDoctorProfileView({
    super.key,
    required this.profile,
    this.onToggleSlot,
    this.onEditProfile,
    this.onDeleteDoctor,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final doctor = profile.doctor;

    return SingleChildScrollView(
      padding: AppSpacing.cardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfileHeader(doctor: doctor),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onEditProfile,
                  icon: Icon(Icons.edit_rounded, size: 18, color: colors.primary),
                  label: Text(AppStrings.editProfile, style: TextStyle(color: colors.primary)),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm + AppSpacing.xs),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.buttonRadius)),
                    side: BorderSide(color: colors.primary.withValues(alpha: 0.3)),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm + AppSpacing.xs),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onDeleteDoctor,
                  icon: Icon(Icons.delete_rounded, size: 18, color: colors.error),
                  label: Text(AppStrings.deleteDoctor, style: TextStyle(color: colors.error)),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm + AppSpacing.xs),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.buttonRadius)),
                    side: BorderSide(color: colors.error.withValues(alpha: 0.3)),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          ProfileStatsGrid(doctor: doctor),
          const SizedBox(height: AppSpacing.lg),
          ProfileAboutSection(doctor: doctor, isEditable: true),
          const SizedBox(height: AppSpacing.lg),
          if (doctor.services.isNotEmpty) ...[
            ProfileServicesSection(doctor: doctor, isEditable: true),
            const SizedBox(height: AppSpacing.lg),
          ],
          ProfileScheduleSection(
            slots: profile.availableSlots,
            canManage: true,
            onToggleSlot: (slotId) => onToggleSlot?.call(),
          ),
          const SizedBox(height: AppSpacing.lg),
          ProfileReviewsSection(
            reviews: profile.reviews,
            averageRating: doctor.rating,
            totalReviews: doctor.reviewsCount,
          ),
          const SizedBox(height: AppSpacing.bottomNavHeight),
        ],
      ),
    );
  }
}
