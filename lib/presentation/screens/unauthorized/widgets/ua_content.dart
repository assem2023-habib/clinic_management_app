import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';

class UaContent extends StatelessWidget {
  const UaContent({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Column(
      children: [
        Text(
          AppStrings.uaTitle,
          style: TextStyle(
            fontSize: AppSpacing.headline,
            fontWeight: FontWeight.w600,
            color: colors.mint,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.sm + AppSpacing.xs),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md + AppSpacing.xs),
          child: Text(
            AppStrings.uaMessage,
            style: TextStyle(
              fontSize: AppSpacing.titleMedium,
              color: colors.sage,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
