import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';
import 'package:clinic_management_app/core/animations/animations.dart';

class OnboardingPage extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final bool isLast;

  const OnboardingPage({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
        child: Column(
          children: [
            const Spacer(flex: 2),
            AnimatedEntrance(
              type: EntranceType.fadeScaleIn,
              delay: Duration.zero,
              duration: AppDurations.dSlow,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      iconColor.withValues(alpha: 0.2),
                      colors.scaffoldBg,
                    ],
                    radius: 1.2,
                  ),
                ),
                child: Center(
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colors.surface,
                      boxShadow: [
                        BoxShadow(
                          color: iconColor.withValues(alpha: 0.15),
                          blurRadius: 40,
                          spreadRadius: 8,
                        ),
                      ],
                    ),
                    child: Icon(icon, size: 64, color: iconColor),
                  ),
                ),
              ),
            ),
            const Spacer(flex: 1),
            AnimatedEntrance(
              type: EntranceType.fadeSlideUp,
              delay: const Duration(milliseconds: 300),
              duration: AppDurations.dFadeIn,
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: AppSpacing.titleError,
                  fontWeight: FontWeight.bold,
                  color: colors.textPrimary,
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            AnimatedEntrance(
              type: EntranceType.fadeSlideUp,
              delay: const Duration(milliseconds: 450),
              duration: AppDurations.dFadeIn,
              child: Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: AppSpacing.subtitle,
                  color: colors.textSecondary,
                  height: 1.6,
                ),
              ),
            ),
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}