import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';

class SfIconSection extends StatelessWidget {
  const SfIconSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return SizedBox(
      width: 128,
      height: 128,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 192,
            height: 192,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors.warning.withValues(alpha: 0.12),
              boxShadow: [
                BoxShadow(
                  color: colors.warning.withValues(alpha: 0.12),
                  blurRadius: 60,
                  spreadRadius: 20,
                ),
              ],
            ),
          ),
          Container(
            width: 128,
            height: 128,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors.cardBg.withValues(alpha: 0.6),
              border: Border.all(
                color: colors.warning.withValues(alpha: 0.2),
              ),
            ),
            child: const Icon(
              Icons.search_off_rounded,
              size: 64,
              color: colors.warning,
            ),
          ),
        ],
      ),
    );
  }
}
