import 'package:clinic_management_app/core/constants/app_icons.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';

class UfBottomNav extends StatelessWidget {
  final int activeIndex;
  final ValueChanged<int>? onTabSelected;

  const UfBottomNav({
    super.key,
    this.activeIndex = 2,
    this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Container(
      height: 80,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildTab(colors, 0, AppIcons.gridView, AppStrings.ufNavDashboard),
          _buildTab(colors, 1, AppIcons.description, AppStrings.ufNavRecords),
          _buildActiveTab(colors, 2, AppIcons.upload, AppStrings.ufNavUpload),
          _buildTab(colors, 3, AppIcons.accountCircle, AppStrings.ufNavProfile),
        ],
      ),
    );
  }

  Widget _buildTab(AppColorSet colors, int index, IconData icon, String label) {
    final isActive = index == activeIndex;
    return GestureDetector(
      onTap: () => onTabSelected?.call(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: AppSpacing.iconSize,
            color: isActive
                ? colors.mint
                : colors.textMuted,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            label,
            style: TextStyle(
              fontSize: AppSpacing.bodySmall,
              fontWeight: FontWeight.w600,
              color: isActive
                  ? colors.mint
                  : colors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveTab(AppColorSet colors, int index, IconData icon, String label) {
    return GestureDetector(
      onTap: () => onTabSelected?.call(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: colors.cardBorder,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: AppSpacing.iconSize, color: colors.iconGreen),
            const SizedBox(height: AppSpacing.xs),
            Text(
              label,
            style: TextStyle(
                fontSize: AppSpacing.bodySmall,
                fontWeight: FontWeight.w600,
                color: colors.iconGreen,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

