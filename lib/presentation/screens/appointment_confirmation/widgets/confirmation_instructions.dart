import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';

class ConfirmationInstructions extends StatelessWidget {
  const ConfirmationInstructions({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.importantInstructions,
          style: TextStyle(
            fontSize: AppSpacing.bodyMedium,
            fontWeight: FontWeight.w600,
            color: colors.textPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.sm + AppSpacing.xs),
        _instructionItem(context, AppStrings.instructionArriveEarly),
        const SizedBox(height: AppSpacing.sm),
        _instructionItem(context, AppStrings.instructionBringId),
      ],
    );
  }

  Widget _instructionItem(BuildContext context, String text) {
    final colors = AppColors.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: AppSpacing.bulletSize,
          height: AppSpacing.bulletSize,
          decoration: BoxDecoration(
            color: colors.secondary,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: AppSpacing.bodyMedium, color: colors.textSecondary),
          ),
        ),
      ],
    );
  }
}
