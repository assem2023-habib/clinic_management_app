import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class PsHeroIcon extends StatelessWidget {
  const PsHeroIcon({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return SizedBox(
      width: 192,
      height: 192,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              color: colors.emerald.withValues(alpha: 0.1),
              shape: BoxShape.circle,
              border: Border.all(color: colors.mint.withValues(alpha: 0.2)),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Icon(Icons.shield_rounded, size: 80, color: colors.mint),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: colors.emerald,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    child: const Icon(Icons.add, size: 18, color: colors.scaffoldBg),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().shakeY(duration: 6.seconds, amount: 8, curve: Curves.easeInOut);
  }
}
