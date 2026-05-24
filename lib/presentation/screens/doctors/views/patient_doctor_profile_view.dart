import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/domain/entities/doctor_profile_entity.dart';
import 'package:clinic_management_app/presentation/widgets/doctor_profile/profile_header.dart';
import 'package:clinic_management_app/presentation/widgets/doctor_profile/profile_stats_grid.dart';
import 'package:clinic_management_app/presentation/widgets/doctor_profile/profile_about_section.dart';
import 'package:clinic_management_app/presentation/widgets/doctor_profile/profile_services_section.dart';
import 'package:clinic_management_app/presentation/widgets/doctor_profile/profile_qualifications_section.dart';
import 'package:clinic_management_app/presentation/widgets/doctor_profile/profile_reviews_section.dart';
import 'package:clinic_management_app/presentation/widgets/doctor_profile/profile_schedule_section.dart';

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
              label: const Text('حجز موعد', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
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
    final controller = TextEditingController();
    double rating = 5.0;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('أضف تقييمك'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (i) => IconButton(
                  onPressed: () => setState(() => rating = (i + 1).toDouble()),
                  icon: Icon(
                    i < rating.round() ? Icons.star_rounded : Icons.star_outline_rounded,
                    color: Colors.amber,
                    size: 32,
                  ),
                )),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: controller,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'اكتب تعليقك...',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('إرسال'),
            ),
          ],
        ),
      ),
    );
  }
}
