import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_icons.dart';
import 'package:clinic_management_app/core/animations/animations.dart';

class UaIconSection extends StatelessWidget {
  const UaIconSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return PulseAnimation(
      minScale: 1.0,
      maxScale: 1.05,
      duration: AppDurations.dBounce,
      child: SizedBox(
        width: 160,
        height: 160,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.mint.withValues(alpha: 0.05),
              ),
            ),
            Container(
              width: 128,
              height: 128,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.surfaceDark.withValues(alpha: 0.4),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.08),
                ),
              ),
              child: Icon(
                AppIcons.lock,
                size: 64,
                color: colors.mint,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
