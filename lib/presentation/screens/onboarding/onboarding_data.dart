import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/domain/entities/user_role.dart';

class OnboardingItem {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;

  OnboardingItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
  });
}

class OnboardingData {
  static List<OnboardingItem> get adminSteps => [
        OnboardingItem(
          icon: Icons.admin_panel_settings_rounded,
          iconColor: AppColors.dark.primary,
          title: AppStrings.onboardingWelcomeTitle,
          subtitle: AppStrings.onboardingWelcomeSubtitle,
        ),
        OnboardingItem(
          icon: Icons.calendar_month_rounded,
          iconColor: AppColors.dark.secondary,
          title: AppStrings.onboardingScheduleTitle,
          subtitle: AppStrings.onboardingScheduleSubtitle,
        ),
        OnboardingItem(
          icon: Icons.dashboard_customize_rounded,
          iconColor: AppColors.dark.primaryLight,
          title: AppStrings.onboardingDashboardTitle,
          subtitle: AppStrings.onboardingDashboardSubtitle,
        ),
      ];

  static List<OnboardingItem> get doctorSteps => [
        OnboardingItem(
          icon: Icons.local_hospital_rounded,
          iconColor: AppColors.dark.primary,
          title: AppStrings.onboardingDoctorWelcomeTitle,
          subtitle: AppStrings.onboardingDoctorWelcomeSubtitle,
        ),
        OnboardingItem(
          icon: Icons.schedule_rounded,
          iconColor: AppColors.dark.secondary,
          title: AppStrings.onboardingDoctorScheduleTitle,
          subtitle: AppStrings.onboardingDoctorScheduleSubtitle,
        ),
        OnboardingItem(
          icon: Icons.connect_without_contact_rounded,
          iconColor: AppColors.dark.primaryLight,
          title: AppStrings.onboardingDoctorCommunicationTitle,
          subtitle: AppStrings.onboardingDoctorCommunicationSubtitle,
        ),
      ];

  static List<OnboardingItem> get receptionistSteps => [
        OnboardingItem(
          icon: Icons.assignment_ind_rounded,
          iconColor: AppColors.dark.primary,
          title: AppStrings.onboardingReceptionistTitle,
          subtitle: AppStrings.onboardingReceptionistSubtitle,
        ),
        OnboardingItem(
          icon: Icons.calendar_month_rounded,
          iconColor: AppColors.dark.secondary,
          title: AppStrings.onboardingReceptionistApptsTitle,
          subtitle: AppStrings.onboardingReceptionistApptsSubtitle,
        ),
        OnboardingItem(
          icon: Icons.contact_phone_rounded,
          iconColor: AppColors.dark.primaryLight,
          title: AppStrings.onboardingReceptionistCoordTitle,
          subtitle: AppStrings.onboardingReceptionistCoordSubtitle,
        ),
      ];

  static List<OnboardingItem> get patientSteps => [
        OnboardingItem(
          icon: Icons.person_pin_rounded,
          iconColor: AppColors.dark.primary,
          title: AppStrings.onboardingPatientTitle,
          subtitle: AppStrings.onboardingPatientSubtitle,
        ),
        OnboardingItem(
          icon: Icons.calendar_today_rounded,
          iconColor: AppColors.dark.secondary,
          title: AppStrings.onboardingPatientApptsTitle,
          subtitle: AppStrings.onboardingPatientApptsSubtitle,
        ),
        OnboardingItem(
          icon: Icons.health_and_safety_rounded,
          iconColor: AppColors.dark.primaryLight,
          title: AppStrings.onboardingPatientRecordsTitle,
          subtitle: AppStrings.onboardingPatientRecordsSubtitle,
        ),
      ];

  static List<OnboardingItem> getItems(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return adminSteps;
      case UserRole.doctor:
        return doctorSteps;
      case UserRole.receptionist:
        return receptionistSteps;
      case UserRole.patient:
        return patientSteps;
    }
  }
}
