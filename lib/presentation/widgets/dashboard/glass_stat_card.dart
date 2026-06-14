import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';

class GlassStatCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final String? value;
  final int index;

  const GlassStatCard({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    this.value,
    this.index = 0,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final delay = Duration(milliseconds: index * 120);

    final card = Container(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, size: 20, color: color),
                ),
                const SizedBox(height: 8),
                if (value != null)
                  Text(
                    value!,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: color,
                      height: 1,
                    ),
                  ),
                const SizedBox(height: 4),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    return card
        .animate()
        .fadeIn(duration: 400.ms, delay: delay, curve: Curves.easeOutCubic)
        .scaleXY(
          begin: 0.85,
          end: 1.0,
          duration: 500.ms,
          delay: delay,
          curve: Curves.easeOutBack,
        );
  }
}
