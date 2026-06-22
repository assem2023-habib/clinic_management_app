import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';

class SpIconSection extends StatelessWidget {
  const SpIconSection({super.key});

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
              color: colors.mint.withValues(alpha: 0.2),
              boxShadow: [
                BoxShadow(
                  color: colors.mint.withValues(alpha: 0.2),
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
                color: colors.mint.withValues(alpha: 0.2),
              ),
              boxShadow: [
                BoxShadow(
                  color: colors.mint.withValues(alpha: 0.05),
                  blurRadius: 20,
                ),
              ],
            ),
            child: Icon(
              Icons.gpp_maybe_rounded,
              size: 64,
              color: colors.mint,
            ),
          ),
        ],
      ),
    );
  }
}
