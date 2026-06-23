import 'package:clinic_management_app/core/constants/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_routes.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/presentation/blocs/onboarding/onboarding_cubit.dart';
import 'package:clinic_management_app/domain/entities/user_role.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.iconContainer),
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colors.surface,
                  boxShadow: [
                    BoxShadow(
                      color: colors.primary.withValues(alpha: 0.15),
                      blurRadius: 30,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: Icon(AppIcons.medicalServices, size: 44, color: colors.primary),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                AppStrings.roleSelectionSystemName,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: AppSpacing.titleError,
                  fontWeight: FontWeight.w800,
                  color: colors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                AppStrings.chooseRoleToStart,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: AppSpacing.bodyMedium,
                  color: colors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: Column(
                    children: [
                      _buildRoleCard(
                        context,
                        icon: AppIcons.adminPanelSettings,
                        title: AppStrings.roleAdmin,
                        subtitle: AppStrings.adminSubtitle,
                        role: UserRole.admin,
                        color: colors.primary,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _buildRoleCard(
                        context,
                        icon: AppIcons.localHospital,
                        title: AppStrings.roleDoctor,
                        subtitle: AppStrings.doctorSubtitle,
                        role: UserRole.doctor,
                        color: colors.secondary,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _buildRoleCard(
                        context,
                        icon: AppIcons.assignmentInd,
                        title: AppStrings.roleReceptionist,
                        subtitle: AppStrings.receptionistSubtitle,
                        role: UserRole.receptionist,
                        color: colors.accent,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _buildRoleCard(
                        context,
                        icon: AppIcons.personPin,
                        title: AppStrings.rolePatient,
                        subtitle: AppStrings.patientSubtitle,
                        role: UserRole.patient,
                        color: colors.primaryLight,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required UserRole role,
    required Color color,
  }) {
    final colors = AppColors.of(context);

    return GestureDetector(
      onTap: () {
        context.read<OnboardingCubit>().selectRole(role);
        Navigator.pushNamed(context, AppRoutes.onboarding);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: colors.cardBg,
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          border: Border.all(color: colors.divider.withValues(alpha: 0.3)),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: AppSpacing.caption,
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(AppIcons.back, color: colors.textLight, size: 16),
          ],
        ),
      ),
    );
  }
}

