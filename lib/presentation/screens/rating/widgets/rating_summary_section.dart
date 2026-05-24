import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/presentation/blocs/rating/rating_state.dart';

class RatingSummarySection extends StatelessWidget {
  final double averageRating;
  final int totalReviews;
  final List<RatingDistribution> distribution;

  const RatingSummarySection({
    super.key,
    required this.averageRating,
    required this.totalReviews,
    required this.distribution,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.cardBg.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(color: colors.divider.withValues(alpha: 0.08)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.rating,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: colors.textSecondary, letterSpacing: 0.5),
                ),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      averageRating.toStringAsFixed(1),
                      style: TextStyle(fontSize: 48, fontWeight: FontWeight.w800, color: colors.primary, height: 1),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      'من 5.0',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: colors.textSecondary),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: List.generate(5, (i) {
                    final starIndex = i + 1;
                    final fill = starIndex <= averageRating.round();
                    final half = !fill && starIndex - 1 < averageRating;
                    return Padding(
                      padding: const EdgeInsets.only(left: 2),
                      child: Icon(
                        fill ? Icons.star_rounded : (half ? Icons.star_half_rounded : Icons.star_outline_rounded),
                        color: colors.primary,
                        size: 24,
                      ),
                    );
                  }),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  '${AppStrings.basedOnReviews} $totalReviews ${AppStrings.reviewsFromPatients}',
                  style: TextStyle(fontSize: 12, color: colors.textSecondary),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: distribution.map((d) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  children: [
                    SizedBox(
                      width: 16,
                      child: Text(
                        '${d.star}',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: colors.textSecondary),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: colors.divider.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: d.percentage / 100,
                          child: Container(
                            decoration: BoxDecoration(
                              color: colors.primary,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
