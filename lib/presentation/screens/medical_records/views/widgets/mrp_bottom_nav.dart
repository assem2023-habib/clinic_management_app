import 'package:clinic_management_app/core/constants/app_icons.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';

class MrpBottomNav extends StatelessWidget {
  final int activeIndex;
  final ValueChanged<int>? onTabSelected;

  const MrpBottomNav({
    super.key,
    this.activeIndex = 1,
    this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Container(
      height: 80,
      padding: const EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.md, AppSpacing.sm),
      decoration: BoxDecoration(
        color: colors.cardBg.withValues(alpha: 0.4),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
        border: Border(
          top: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildTab(colors, 0, AppIcons.home, AppStrings.mrNavHome),
          _buildActiveTab(colors, 1, AppIcons.history, AppStrings.mrNavRecords),
          _buildTab(colors, 2, AppIcons.monitorHeart, AppStrings.mrNavVitals),
          _buildTab(colors, 3, AppIcons.person, AppStrings.mrNavProfile),
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
                ? colors.primary
                : colors.divider,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            label,
            style: TextStyle(
              fontSize: AppSpacing.bodySmall,
              fontWeight: FontWeight.w500,
              color: isActive
                  ? colors.primary
                  : colors.divider,
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
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
        decoration: BoxDecoration(
          color: colors.accent,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: AppSpacing.iconSize, color: colors.timelineBg),
            const SizedBox(height: AppSpacing.xs),
            Text(
              label,
            style: TextStyle(
                fontSize: AppSpacing.bodySmall,
                fontWeight: FontWeight.w500,
                color: colors.timelineBg,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

