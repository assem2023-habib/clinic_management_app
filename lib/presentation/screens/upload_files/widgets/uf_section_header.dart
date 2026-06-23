import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';

class UfSectionHeader extends StatelessWidget {
  final String label;
  final String? actionLabel;
  final VoidCallback? onAction;

  const UfSectionHeader({
    super.key,
    required this.label,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(fontSize: AppSpacing.bodySmall, fontWeight: FontWeight.w600, color: colors.textLight, letterSpacing: 0.05),
        ),
        const Spacer(),
        if (actionLabel != null)
          GestureDetector(
            onTap: onAction,
            child: Text(
              actionLabel!,
              style: TextStyle(fontSize: AppSpacing.bodyMedium, fontWeight: FontWeight.w500, color: colors.primary),
            ),
          ),
      ],
    );
  }
}

