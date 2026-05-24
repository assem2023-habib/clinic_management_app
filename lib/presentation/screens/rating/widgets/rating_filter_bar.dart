import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';
import 'package:clinic_management_app/presentation/blocs/rating/rating_event.dart';

class RatingFilterBar extends StatelessWidget {
  final RatingFilter currentFilter;
  final ValueChanged<RatingFilter> onFilterChanged;

  const RatingFilterBar({
    super.key,
    required this.currentFilter,
    required this.onFilterChanged,
  });

  static const _filters = [
    (filter: RatingFilter.newest, label: 'الأحدث'),
    (filter: RatingFilter.highest, label: 'الأعلى تقييماً'),
    (filter: RatingFilter.withPhotos, label: 'مع صور'),
    (filter: RatingFilter.lowest, label: 'الأقل تقييماً'),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) {
          final f = _filters[index];
          final isActive = f.filter == currentFilter;

          return GestureDetector(
            onTap: () => onFilterChanged(f.filter),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
              decoration: BoxDecoration(
                color: isActive ? colors.primary : colors.cardBg,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                f.label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: isActive ? Colors.white : colors.textPrimary,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
