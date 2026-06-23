import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:clinic_management_app/core/constants/app_icons.dart';

class UaIconSection extends StatelessWidget {
  const UaIconSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return SizedBox(
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
    ).animate().scale(
      duration: 4.seconds,
      begin: const Offset(1.0, 1.0),
      end: const Offset(1.05, 1.05),
      curve: Curves.easeInOut,
    ).move(
      duration: 4.seconds,
      begin: const Offset(0, 0),
      end: const Offset(0, -15),
      curve: Curves.easeInOut,
    );
  }
}
