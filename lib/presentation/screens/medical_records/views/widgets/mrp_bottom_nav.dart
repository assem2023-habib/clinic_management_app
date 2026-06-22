import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';

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
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
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
          _buildTab(0, Icons.home_rounded, AppStrings.mrNavHome),
          _buildActiveTab(1, Icons.history_rounded, AppStrings.mrNavRecords),
          _buildTab(2, Icons.monitor_heart_rounded, AppStrings.mrNavVitals),
          _buildTab(3, Icons.person_rounded, AppStrings.mrNavProfile),
        ],
      ),
    );
  }

  Widget _buildTab(int index, IconData icon, String label) {
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
                ? colors.primary
                : colors.divider,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
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

  Widget _buildActiveTab(int index, IconData icon, String label) {
    return GestureDetector(
      onTap: () => onTabSelected?.call(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: colors.accent,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 24, color: colors.timelineBg),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
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
