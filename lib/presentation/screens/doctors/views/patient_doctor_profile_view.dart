import 'package:clinic_management_app/core/constants/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/core/utils/app_toast.dart';
import 'package:clinic_management_app/domain/entities/doctor_profile_entity.dart';
import 'package:clinic_management_app/presentation/blocs/auth/auth_cubit.dart';
import 'package:clinic_management_app/presentation/blocs/rating/rating_bloc.dart';
import 'package:clinic_management_app/presentation/blocs/rating/rating_event.dart';
import 'package:clinic_management_app/presentation/blocs/supervision/supervision_bloc.dart';
import 'package:clinic_management_app/presentation/widgets/doctor_profile/profile_header.dart';
import 'package:clinic_management_app/presentation/widgets/doctor_profile/profile_stats_grid.dart';
import 'package:clinic_management_app/presentation/widgets/doctor_profile/profile_about_section.dart';
import 'package:clinic_management_app/presentation/widgets/doctor_profile/profile_services_section.dart';
import 'package:clinic_management_app/presentation/widgets/doctor_profile/profile_qualifications_section.dart';
import 'package:clinic_management_app/presentation/widgets/doctor_profile/profile_reviews_section.dart';
import 'package:clinic_management_app/presentation/widgets/doctor_profile/profile_schedule_section.dart';
import 'package:clinic_management_app/presentation/widgets/rating_bottom_sheet.dart';

class PatientDoctorProfileView extends StatefulWidget {
  final DoctorProfileEntity profile;
  final VoidCallback? onBookAppointment;

  const PatientDoctorProfileView({
    super.key,
    required this.profile,
    this.onBookAppointment,
  });

  @override
  State<PatientDoctorProfileView> createState() => _PatientDoctorProfileViewState();
}

class _PatientDoctorProfileViewState extends State<PatientDoctorProfileView> {
  _SupervisionStatus _supervisionStatus = _SupervisionStatus.none;
  String? _pendingRequestId;

  @override
  void initState() {
    super.initState();
    _checkSupervisionStatus();
  }

  void _checkSupervisionStatus() {
    final authState = context.read<AuthCubit>().state;
    final patientId = authState.userId ?? '';
    final bloc = context.read<SupervisionBloc>();
    // Load patient doctors to check existing supervision
    bloc.add(LoadPatientDoctors(patientId));
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final doctor = widget.profile.doctor;

    return BlocListener<SupervisionBloc, SupervisionState>(
      listener: (context, state) {
        final doctorId = doctor.id;
        if (state is PatientDoctorsLoaded) {
          final isSupervised = state.doctors.any((s) => s.doctorId == doctorId && s.status == 'active');
          if (isSupervised) {
            setState(() => _supervisionStatus = _SupervisionStatus.supervised);
          } else {
            // Now check requests
            final patientId = context.read<AuthCubit>().state.userId ?? '';
            context.read<SupervisionBloc>().add(LoadPatientRequests(patientId));
          }
        } else if (state is PatientRequestsLoaded) {
          final pendingReq = state.requests.where(
            (r) => r.doctorId == doctorId && r.status == 'pending',
          );
          if (pendingReq.isNotEmpty) {
            setState(() {
              _supervisionStatus = _SupervisionStatus.pending;
              _pendingRequestId = pendingReq.first.id;
            });
          } else {
            setState(() => _supervisionStatus = _SupervisionStatus.none);
          }
        } else if (state is SupervisionOperationSuccess) {
          showAppToast(context, state.message);
          _checkSupervisionStatus();
        } else if (state is SupervisionError) {
          showAppToast(context, state.message);
        }
      },
      child: SingleChildScrollView(
        padding: AppSpacing.screenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileHeader(doctor: doctor),
            const SizedBox(height: AppSpacing.md),
            _buildSupervisionBadge(colors),
            const SizedBox(height: AppSpacing.lg),
            ProfileStatsGrid(doctor: doctor),
            const SizedBox(height: AppSpacing.lg),
            ProfileAboutSection(doctor: doctor),
            const SizedBox(height: AppSpacing.lg),
            if (doctor.services.isNotEmpty) ...[
              ProfileServicesSection(doctor: doctor),
              const SizedBox(height: AppSpacing.lg),
            ],
            ProfileQualificationsSection(doctor: doctor),
            const SizedBox(height: AppSpacing.lg),
            ProfileScheduleSection(slots: widget.profile.availableSlots),
            const SizedBox(height: AppSpacing.lg),
            ProfileReviewsSection(
              reviews: widget.profile.reviews,
              averageRating: doctor.rating,
              totalReviews: doctor.reviewsCount,
              canAddReview: true,
              onAddReview: () => _showReviewDialog(context),
            ),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: widget.onBookAppointment,
                icon: const Icon(AppIcons.eventAvailable, size: AppSpacing.iconMedium),
                label: Text(AppStrings.bookAppointment, style: TextStyle(fontSize: AppSpacing.bodyLarge, fontWeight: FontWeight.w600)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.cardRadius)),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.bottomNavHeight),
          ],
        ),
      ),
    );
  }

  Widget _buildSupervisionBadge(AppColorSet colors) {
    switch (_supervisionStatus) {
      case _SupervisionStatus.supervised:
        return _SupervisionBadgeCard(
          icon: AppIcons.verified,
          label: AppStrings.mySupervisingDoctor,
          color: colors.success,
          colors: colors,
          actionLabel: AppStrings.removeSupervision,
          actionIcon: AppIcons.linkOff,
          onAction: () {
            final patientId = context.read<AuthCubit>().state.userId ?? '';
            context.read<SupervisionBloc>().add(
              PatientRemoveDoctor(patientId, widget.profile.doctor.id),
            );
          },
        );
      case _SupervisionStatus.pending:
        return _SupervisionBadgeCard(
          icon: AppIcons.hourglassTop,
          label: AppStrings.pendingSupervisionRequest,
          color: colors.warning,
          colors: colors,
          actionLabel: AppStrings.cancelRequest,
          actionIcon: AppIcons.cancel,
          onAction: () {
            if (_pendingRequestId != null) {
              context.read<SupervisionBloc>().add(CancelRequest(_pendingRequestId!));
            }
          },
        );
      case _SupervisionStatus.none:
        return SizedBox(
          width: double.infinity,
          height: 48,
          child: OutlinedButton.icon(
            onPressed: () {
              final patientId = context.read<AuthCubit>().state.userId ?? '';
              context.read<SupervisionBloc>().add(
                CreateSupervisionRequestEvent(patientId, widget.profile.doctor.id),
              );
            },
            icon: const Icon(AppIcons.supervisorAccount, size: AppSpacing.iconSmall),
            label: Text(AppStrings.requestSupervision, style: TextStyle(fontSize: AppSpacing.bodyMedium, fontWeight: FontWeight.w600)),
            style: OutlinedButton.styleFrom(
              foregroundColor: colors.primary,
              side: BorderSide(color: colors.primary, width: 1.5),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.md - AppSpacing.xxs)),
            ),
          ),
        );
    }
  }

  void _showReviewDialog(BuildContext context) {
    final doctor = widget.profile.doctor;

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
          showAppToast(context, AppStrings.ratingSentConfirmation);
        },
      ),
    );
  }
}

enum _SupervisionStatus { none, pending, supervised }

class _SupervisionBadgeCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final AppColorSet colors;
  final String actionLabel;
  final IconData actionIcon;
  final VoidCallback onAction;

  const _SupervisionBadgeCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.colors,
    required this.actionLabel,
    required this.actionIcon,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm + AppSpacing.xs),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppSpacing.md - AppSpacing.xxs),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: AppSpacing.iconMedium),
          const SizedBox(width: AppSpacing.ten),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: AppSpacing.bodyMedium,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ),
          Material(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(AppSpacing.sm),
            child: InkWell(
              onTap: onAction,
              borderRadius: BorderRadius.circular(AppSpacing.sm),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.ten, vertical: AppSpacing.six),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(actionIcon, size: 14, color: color),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      actionLabel,
                      style: TextStyle(fontSize: AppSpacing.bodySmall, fontWeight: FontWeight.w600, color: color),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
