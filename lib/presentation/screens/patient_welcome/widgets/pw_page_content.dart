import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class PwPageContent extends StatelessWidget {
  final String title;
  final String subtitle;

  const PwPageContent({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Sora',
              fontSize: 28,
              fontWeight: FontWeight.w600,
              height: 1.2,
              letterSpacing: -0.01,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Sora',
              fontSize: 16,
              fontWeight: FontWeight.w400,
              height: 1.5,
              color: colors.textMuted.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}
