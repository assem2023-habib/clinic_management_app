import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/domain/entities/user_role.dart';
import 'package:clinic_management_app/core/constants/app_icons.dart';

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
          icon: AppIcons.adminPanelSettings,
          iconColor: AppColors.dark.primary,
          title: AppStrings.onboardingWelcomeTitle,
          subtitle: AppStrings.onboardingWelcomeSubtitle,
        ),
        OnboardingItem(
          icon: AppIcons.calendarMonth,
          iconColor: AppColors.dark.secondary,
          title: AppStrings.onboardingScheduleTitle,
          subtitle: AppStrings.onboardingScheduleSubtitle,
        ),
        OnboardingItem(
          icon: AppIcons.dashboardCustomize,
          iconColor: AppColors.dark.primaryLight,
          title: AppStrings.onboardingDashboardTitle,
          subtitle: AppStrings.onboardingDashboardSubtitle,
        ),
      ];

  static List<OnboardingItem> get doctorSteps => [
        OnboardingItem(
          icon: AppIcons.localHospital,
          iconColor: AppColors.dark.primary,
          title: AppStrings.onboardingDoctorWelcomeTitle,
          subtitle: AppStrings.onboardingDoctorWelcomeSubtitle,
        ),
        OnboardingItem(
          icon: AppIcons.schedule,
          iconColor: AppColors.dark.secondary,
          title: AppStrings.onboardingDoctorScheduleTitle,
          subtitle: AppStrings.onboardingDoctorScheduleSubtitle,
        ),
        OnboardingItem(
          icon: AppIcons.connectWithoutContact,
          iconColor: AppColors.dark.primaryLight,
          title: AppStrings.onboardingDoctorCommunicationTitle,
          subtitle: AppStrings.onboardingDoctorCommunicationSubtitle,
        ),
      ];

  static List<OnboardingItem> get receptionistSteps => [
        OnboardingItem(
          icon: AppIcons.assignmentInd,
          iconColor: AppColors.dark.primary,
          title: AppStrings.onboardingReceptionistTitle,
          subtitle: AppStrings.onboardingReceptionistSubtitle,
        ),
        OnboardingItem(
          icon: AppIcons.calendarMonth,
          iconColor: AppColors.dark.secondary,
          title: AppStrings.onboardingReceptionistApptsTitle,
          subtitle: AppStrings.onboardingReceptionistApptsSubtitle,
        ),
        OnboardingItem(
          icon: AppIcons.contactPhone,
          iconColor: AppColors.dark.primaryLight,
          title: AppStrings.onboardingReceptionistCoordTitle,
          subtitle: AppStrings.onboardingReceptionistCoordSubtitle,
        ),
      ];

  static List<OnboardingItem> get patientSteps => [
        OnboardingItem(
          icon: AppIcons.personPin,
          iconColor: AppColors.dark.primary,
          title: AppStrings.onboardingPatientTitle,
          subtitle: AppStrings.onboardingPatientSubtitle,
        ),
        OnboardingItem(
          icon: AppIcons.calendarToday,
          iconColor: AppColors.dark.secondary,
          title: AppStrings.onboardingPatientApptsTitle,
          subtitle: AppStrings.onboardingPatientApptsSubtitle,
        ),
        OnboardingItem(
          icon: AppIcons.healthAndSafety,
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
