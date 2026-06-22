import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';

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
          _buildTab(colors, 0, Icons.grid_view_rounded, AppStrings.ufNavDashboard),
          _buildTab(colors, 1, Icons.description_rounded, AppStrings.ufNavRecords),
          _buildActiveTab(colors, 2, Icons.cloud_upload_rounded, AppStrings.ufNavUpload),
          _buildTab(colors, 3, Icons.account_circle_rounded, AppStrings.ufNavProfile),
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
            size: 24,
            color: isActive
                ? colors.mint
                : colors.textMuted,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
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
            Icon(icon, size: 24, color: colors.iconGreen),
            const SizedBox(height: 4),
            Text(
              label,
            style: TextStyle(
                fontSize: 12,
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
