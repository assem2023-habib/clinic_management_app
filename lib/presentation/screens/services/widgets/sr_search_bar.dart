import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';

class SrSearchBar extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onSearch;

  const SrSearchBar({super.key, this.controller, this.onSearch});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: colors.cardBg.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(color: colors.divider.withValues(alpha: 0.08)),
      ),
      child: Row(
        children: [
          Icon(Icons.search_rounded, color: colors.textLight, size: 22),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onSearch,
              decoration: InputDecoration(
                hintText: AppStrings.srSearchHint,
                hintStyle: TextStyle(color: colors.textLight.withValues(alpha: 0.5), fontSize: 14),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              style: TextStyle(fontSize: 14, color: colors.textPrimary),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Icon(Icons.tune_rounded, color: colors.primary, size: 22),
        ],
      ),
    );
  }
}
