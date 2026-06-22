import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_routes.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/presentation/blocs/onboarding/onboarding_cubit.dart';
import 'package:clinic_management_app/presentation/blocs/auth/auth_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: 1.2.seconds,
    )..repeat(reverse: true);
    _checkOnboardingStatus();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _checkOnboardingStatus() async {
    await Future.delayed(2.4.seconds);
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
            ScaleTransition(
              scale: _pulseController.drive(
                Tween<double>(begin: 0.95, end: 1.05).chain(
                  CurveTween(curve: Curves.easeInOutSine),
                ),
              ),
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
                    Icons.local_hospital_rounded,
                    size: 56,
                    color: Colors.white,
                  ),
                ),
              ),
            ).animate().fadeIn(duration: 800.ms, curve: Curves.easeOutCubic)
             .scale(delay: 100.ms, duration: 700.ms, begin: const Offset(0.5, 0.5), curve: Curves.easeOutBack),
            const SizedBox(height: 32),
            Text(
              AppStrings.splashTitle,
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.2,
                height: 1.2,
              ),
            ).animate().fadeIn(delay: 500.ms, duration: 600.ms, curve: Curves.easeOutCubic)
             .slideY(begin: 0.4, duration: 600.ms, curve: Curves.easeOutCubic),
            const SizedBox(height: 12),
            Text(
              AppStrings.systemTitle,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withValues(alpha: 0.7),
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5,
              ),
            ).animate().fadeIn(delay: 700.ms, duration: 500.ms, curve: Curves.easeOutCubic)
             .slideY(begin: 0.3, duration: 500.ms, curve: Curves.easeOutCubic),
            const SizedBox(height: 60),
            SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.white.withValues(alpha: 0.6),
                ),
              ),
            ).animate().fadeIn(delay: 1.seconds, duration: 400.ms),
          ],
        ),
      ),
    );
  }
}
