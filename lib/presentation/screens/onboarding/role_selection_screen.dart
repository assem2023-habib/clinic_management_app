import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_routes.dart';
import 'package:clinic_management_app/presentation/blocs/onboarding/onboarding_cubit.dart';
import 'package:clinic_management_app/presentation/blocs/onboarding/onboarding_state.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              Container(
                width: 100,
                height: 100,
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
                child: Icon(Icons.medical_services_rounded, size: 48, color: colors.primary),
              ),
              const SizedBox(height: 32),
              Text(
                'نِظَامُ إِدَارَةِ العِيَادَةِ',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: colors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'اخْتَرْ دَوْرَكَ لِلْبَدْءِ',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: colors.textSecondary,
                ),
              ),
              const Spacer(flex: 2),
              _buildRoleCard(
                context,
                icon: Icons.admin_panel_settings_rounded,
                title: 'مُدِيرُ العِيَادَةِ',
                subtitle: 'إِدَارَةُ العِيَادَةِ، الأَطِبَّاءِ، المَوَاعِيدِ وَالتَّقَارِيرِ',
                role: UserRole.admin,
                color: colors.primary,
              ),
              const SizedBox(height: 16),
              _buildRoleCard(
                context,
                icon: Icons.local_hospital_rounded,
                title: 'طَبِيب',
                subtitle: 'إِدَارَةُ المَوَاعِيدِ، السِّجِلَّاتِ الطِّبِّيَّةِ وَالمَرْضَى',
                role: UserRole.doctor,
                color: colors.secondary,
              ),
              const Spacer(flex: 3),
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
          borderRadius: BorderRadius.circular(16),
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
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
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
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_back_ios_rounded, color: colors.textLight, size: 16),
          ],
        ),
      ),
    );
  }
}
