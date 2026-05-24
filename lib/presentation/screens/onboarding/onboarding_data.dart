import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/domain/entities/user_role.dart';

class OnboardingItem {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;

  const OnboardingItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
  });
}

class OnboardingData {
  static List<OnboardingItem> get adminSteps => [
        const OnboardingItem(
          icon: Icons.admin_panel_settings_rounded,
          iconColor: Color(0xFF80d8a6),
          title: AppStrings.onboardingWelcomeTitle,
          subtitle: AppStrings.onboardingWelcomeSubtitle,
        ),
        const OnboardingItem(
          icon: Icons.calendar_month_rounded,
          iconColor: Color(0xFF40e78c),
          title: AppStrings.onboardingScheduleTitle,
          subtitle: AppStrings.onboardingScheduleSubtitle,
        ),
        const OnboardingItem(
          icon: Icons.dashboard_customize_rounded,
          iconColor: Color(0xFF93ecb8),
          title: AppStrings.onboardingDashboardTitle,
          subtitle: AppStrings.onboardingDashboardSubtitle,
        ),
      ];

  static List<OnboardingItem> get doctorSteps => [
        const OnboardingItem(
          icon: Icons.local_hospital_rounded,
          iconColor: Color(0xFF80d8a6),
          title: AppStrings.onboardingDoctorWelcomeTitle,
          subtitle: AppStrings.onboardingDoctorWelcomeSubtitle,
        ),
        const OnboardingItem(
          icon: Icons.schedule_rounded,
          iconColor: Color(0xFF40e78c),
          title: AppStrings.onboardingDoctorScheduleTitle,
          subtitle: AppStrings.onboardingDoctorScheduleSubtitle,
        ),
        const OnboardingItem(
          icon: Icons.connect_without_contact_rounded,
          iconColor: Color(0xFF93ecb8),
          title: AppStrings.onboardingDoctorCommunicationTitle,
          subtitle: AppStrings.onboardingDoctorCommunicationSubtitle,
        ),
      ];

  static List<OnboardingItem> get receptionistSteps => [
        const OnboardingItem(
          icon: Icons.assignment_ind_rounded,
          iconColor: Color(0xFF80d8a6),
          title: AppStrings.onboardingReceptionistTitle,
          subtitle: AppStrings.onboardingReceptionistSubtitle,
        ),
        const OnboardingItem(
          icon: Icons.calendar_month_rounded,
          iconColor: Color(0xFF40e78c),
          title: AppStrings.onboardingReceptionistApptsTitle,
          subtitle: AppStrings.onboardingReceptionistApptsSubtitle,
        ),
        const OnboardingItem(
          icon: Icons.contact_phone_rounded,
          iconColor: Color(0xFF93ecb8),
          title: AppStrings.onboardingReceptionistCoordTitle,
          subtitle: AppStrings.onboardingReceptionistCoordSubtitle,
        ),
      ];

  static List<OnboardingItem> get patientSteps => [
        const OnboardingItem(
          icon: Icons.person_pin_rounded,
          iconColor: Color(0xFF80d8a6),
          title: AppStrings.onboardingPatientTitle,
          subtitle: AppStrings.onboardingPatientSubtitle,
        ),
        const OnboardingItem(
          icon: Icons.calendar_today_rounded,
          iconColor: Color(0xFF40e78c),
          title: AppStrings.onboardingPatientApptsTitle,
          subtitle: AppStrings.onboardingPatientApptsSubtitle,
        ),
        const OnboardingItem(
          icon: Icons.health_and_safety_rounded,
          iconColor: Color(0xFF93ecb8),
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
