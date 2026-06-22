import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';

class NfIconSection extends StatelessWidget {
  const NfIconSection({super.key});

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
              color: colors.error.withValues(alpha: 0.15),
              boxShadow: [
                BoxShadow(
                  color: colors.error.withValues(alpha: 0.15),
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
                color: colors.error.withValues(alpha: 0.2),
              ),
            ),
            child: Icon(
              Icons.notifications_off_rounded,
              size: 64,
              color: colors.error,
            ),
          ),
        ],
      ),
    );
  }
}
