import 'package:clinic_management_app/core/constants/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_routes.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/presentation/blocs/onboarding/onboarding_cubit.dart';
import 'package:clinic_management_app/presentation/blocs/auth/auth_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';
import 'package:clinic_management_app/core/animations/animations.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    _checkOnboardingStatus();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _checkOnboardingStatus() async {
    await Future.delayed(AppDurations.dSlow + AppDurations.dSlow + AppDurations.dSlow);
    if (!mounted) return;

    final authCubit = context.read<AuthCubit>();
    await authCubit.checkAuthStatus();
    if (!mounted) return;

    if (authCubit.state.isAuthenticated) {
      Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
      return;
    }

    final onboardingCubit = context.read<OnboardingCubit>();
    await onboardingCubit.loadOnboardingStatus();
    if (!mounted) return;
    final completed = onboardingCubit.state.completed;
    Navigator.pushReplacementNamed(
      context,
      completed ? AppRoutes.login : AppRoutes.roleSelection,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [
              colors.primary,
              colors.primaryDark,
              colors.splashBg,
            ],
            radius: 1.8,
            focal: const Alignment(0.0, -0.3),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PulseAnimation(
              minScale: 0.95,
              maxScale: 1.05,
              curve: Curves.easeInOutSine,
              child: Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.25),
                      blurRadius: 40,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Container(
                  margin: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.15),
                  ),
                  child: const Icon(
                    AppIcons.localHospital,
                    size: 56,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            AnimatedEntrance(
              type: EntranceType.fadeSlideUp,
              delay: const Duration(milliseconds: 500),
              duration: AppDurations.dSlow,
              child: Text(
                AppStrings.splashTitle,
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.2,
                  height: 1.2,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm + AppSpacing.xs),
            AnimatedEntrance(
              type: EntranceType.fadeSlideUp,
              delay: const Duration(milliseconds: 700),
              duration: AppDurations.dFadeIn,
              child: Text(
                AppStrings.systemTitle,
                style: TextStyle(
                  fontSize: AppSpacing.bodyMedium,
                  color: Colors.white.withValues(alpha: 0.7),
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            const SizedBox(height: 60),
            AnimatedEntrance(
              type: EntranceType.fade,
              delay: const Duration(seconds: 1),
              duration: AppDurations.dStaggered,
              child: SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.white.withValues(alpha: 0.6),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

