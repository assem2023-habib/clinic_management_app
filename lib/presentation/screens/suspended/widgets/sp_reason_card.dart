import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';

class SpReasonCard extends StatelessWidget {
  const SpReasonCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: const Color(0xFF032515).withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.05),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            AppStrings.spReasonLabel,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF4EDEA3),
              letterSpacing: 0.05,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            AppStrings.spReasonValue,
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFFC6EBD1),
            ),
          ),
        ],
      ),
    );
  }
}
