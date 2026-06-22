import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/presentation/blocs/rating/rating_event.dart';

class RatingFilterBar extends StatelessWidget {
  final RatingFilterOption currentFilter;
  final ValueChanged<RatingFilterOption> onFilterChanged;

  const RatingFilterBar({
    super.key,
    required this.currentFilter,
    required this.onFilterChanged,
  });

  static final _filters = [
    (filter: RatingFilterOption.newest, label: AppStrings.filterNewest),
    (filter: RatingFilterOption.highest, label: AppStrings.filterHighest),
    (filter: RatingFilterOption.withPhotos, label: AppStrings.filterWithPhotos),
    (filter: RatingFilterOption.lowest, label: AppStrings.filterLowest),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
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
