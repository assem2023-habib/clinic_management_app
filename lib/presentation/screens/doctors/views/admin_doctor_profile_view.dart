import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
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
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfileHeader(doctor: doctor),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onEditProfile,
                  icon: Icon(Icons.edit_rounded, size: 18, color: colors.primary),
                  label: Text('تعديل الملف', style: TextStyle(color: colors.primary)),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    side: BorderSide(color: colors.primary.withValues(alpha: 0.3)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onDeleteDoctor,
                  icon: Icon(Icons.delete_rounded, size: 18, color: colors.error),
                  label: Text('حذف الطبيب', style: TextStyle(color: colors.error)),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    side: BorderSide(color: colors.error.withValues(alpha: 0.3)),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ProfileStatsGrid(doctor: doctor),
          const SizedBox(height: 24),
          ProfileAboutSection(doctor: doctor, isEditable: true),
          const SizedBox(height: 24),
          if (doctor.services.isNotEmpty) ...[
            ProfileServicesSection(doctor: doctor, isEditable: true),
            const SizedBox(height: 24),
          ],
          ProfileScheduleSection(
            slots: profile.availableSlots,
            canManage: true,
            onToggleSlot: (slotId) => onToggleSlot?.call(),
          ),
          const SizedBox(height: 24),
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
