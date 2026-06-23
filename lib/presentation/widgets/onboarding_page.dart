import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';

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
            Container(
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
             ).animate().fadeIn(duration: 600.ms, curve: Curves.easeOutCubic)
             .scale(delay: 100.ms, duration: 500.ms, begin: const Offset(0.6, 0.6), curve: Curves.easeOutBack),
            const Spacer(flex: 1),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppSpacing.titleError,
                fontWeight: FontWeight.bold,
                color: colors.textPrimary,
                height: 1.4,
              ),
            ).animate().fadeIn(delay: 300.ms, duration: 500.ms, curve: Curves.easeOutCubic)
             .slideY(begin: 0.3, duration: 500.ms, curve: Curves.easeOutCubic),
            const SizedBox(height: AppSpacing.md),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: colors.textSecondary,
                height: 1.6,
              ),
            ).animate().fadeIn(delay: 450.ms, duration: 500.ms, curve: Curves.easeOutCubic)
             .slideY(begin: 0.3, duration: 500.ms, curve: Curves.easeOutCubic),
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}

