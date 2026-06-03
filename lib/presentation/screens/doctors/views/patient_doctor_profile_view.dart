import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/core/utils/app_toast.dart';
import 'package:clinic_management_app/domain/entities/doctor_profile_entity.dart';
import 'package:clinic_management_app/presentation/blocs/rating/rating_bloc.dart';
import 'package:clinic_management_app/presentation/blocs/rating/rating_event.dart';
import 'package:clinic_management_app/presentation/widgets/doctor_profile/profile_header.dart';
import 'package:clinic_management_app/presentation/widgets/doctor_profile/profile_stats_grid.dart';
import 'package:clinic_management_app/presentation/widgets/doctor_profile/profile_about_section.dart';
import 'package:clinic_management_app/presentation/widgets/doctor_profile/profile_services_section.dart';
import 'package:clinic_management_app/presentation/widgets/doctor_profile/profile_qualifications_section.dart';
import 'package:clinic_management_app/presentation/widgets/doctor_profile/profile_reviews_section.dart';
import 'package:clinic_management_app/presentation/widgets/doctor_profile/profile_schedule_section.dart';
import 'package:clinic_management_app/presentation/widgets/rating_bottom_sheet.dart';

class PatientDoctorProfileView extends StatelessWidget {
  final DoctorProfileEntity profile;
  final VoidCallback? onBookAppointment;

  const PatientDoctorProfileView({
    super.key,
    required this.profile,
    this.onBookAppointment,
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
          const SizedBox(height: 24),
          ProfileStatsGrid(doctor: doctor),
          const SizedBox(height: 24),
          ProfileAboutSection(doctor: doctor),
          const SizedBox(height: 24),
          if (doctor.services.isNotEmpty) ...[
            ProfileServicesSection(doctor: doctor),
            const SizedBox(height: 24),
          ],
          ProfileQualificationsSection(doctor: doctor),
          const SizedBox(height: 24),
          ProfileScheduleSection(slots: profile.availableSlots),
          const SizedBox(height: 24),
          ProfileReviewsSection(
            reviews: profile.reviews,
            averageRating: doctor.rating,
            totalReviews: doctor.reviewsCount,
            canAddReview: true,
            onAddReview: () => _showReviewDialog(context),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: onBookAppointment,
              icon: const Icon(Icons.event_available_rounded, size: 22),
              label: Text(AppStrings.bookAppointment, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  void _showReviewDialog(BuildContext context) {
    final doctor = profile.doctor;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => RatingBottomSheet(
        doctor: doctor,
        onSubmit: (rating, comment) {
          context.read<RatingBloc>().add(RatingCreate(
            type: 'doctor',
            rateableId: doctor.id,
            rateableType: 'App\\Models\\Doctor',
            rating: rating,
            comment: comment.isNotEmpty ? comment : null,
          ));
          showAppToast(context, 'تم إرسال تقييمك ✓');
        },
      ),
    );
  }
}
