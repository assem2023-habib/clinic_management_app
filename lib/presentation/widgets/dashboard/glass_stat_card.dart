import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';
import 'package:clinic_management_app/core/animations/animations.dart';

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
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.six, vertical: AppSpacing.sm),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: AppSpacing.iconMedium, color: color),
                  const SizedBox(height: AppSpacing.six),
                  if (value != null)
                    Text(
                      value!,
                      style: TextStyle(
                        fontSize: AppSpacing.heading,
                        fontWeight: FontWeight.w800,
                        color: color,
                        height: 1.1,
                      ),
                    ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: AppSpacing.labelSmall,
                      fontWeight: FontWeight.w500,
                      color: colors.textSecondary,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    return AnimatedEntrance(
      type: EntranceType.fadeScaleIn,
      index: index,
      staggeredDelay: Duration(milliseconds: index * 120),
      child: card,
    );
  }
}
