import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';

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
        padding: const EdgeInsets.symmetric(horizontal: 32),
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
            ),
            const Spacer(flex: 1),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: colors.textPrimary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: colors.textSecondary,
                height: 1.6,
              ),
            ),
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}
