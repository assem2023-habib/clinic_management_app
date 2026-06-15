import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';
import 'package:clinic_management_app/domain/entities/doctor_profile_entity.dart';
import 'package:clinic_management_app/presentation/widgets/doctor_profile/profile_header.dart';
import 'package:clinic_management_app/presentation/widgets/doctor_profile/profile_stats_grid.dart';
import 'package:clinic_management_app/presentation/widgets/doctor_profile/profile_about_section.dart';
import 'package:clinic_management_app/presentation/widgets/doctor_profile/profile_services_section.dart';
import 'package:clinic_management_app/presentation/widgets/doctor_profile/profile_schedule_section.dart';
import 'package:clinic_management_app/presentation/widgets/doctor_profile/profile_reviews_section.dart';

class DoctorSelfProfileView extends StatelessWidget {
  final DoctorProfileEntity profile;
  final VoidCallback? onToggleSlot;

  const DoctorSelfProfileView({
    super.key,
    required this.profile,
    this.onToggleSlot,
  });

  @override
  Widget build(BuildContext context) {
    final doctor = profile.doctor;

    return SingleChildScrollView(
      padding: AppSpacing.cardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfileHeader(doctor: doctor),
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
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}
