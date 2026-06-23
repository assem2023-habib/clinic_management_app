import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/domain/entities/review_entity.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';

class ProfileReviewsSection extends StatelessWidget {
  final List<ReviewEntity> reviews;
  final double? averageRating;
  final int? totalReviews;
  final bool canAddReview;
  final VoidCallback? onAddReview;

  const ProfileReviewsSection({
    super.key,
    required this.reviews,
    this.averageRating,
    this.totalReviews,
    this.canAddReview = false,
    this.onAddReview,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(AppStrings.reviews, style: TextStyle(fontSize: AppSpacing.titleMedium, fontWeight: FontWeight.w600, color: colors.textPrimary)),
            TextButton(
              onPressed: () {},
              child: Text(AppStrings.viewAll, style: TextStyle(color: colors.primary)),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm + AppSpacing.xs),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm + AppSpacing.xs),
              decoration: BoxDecoration(
                color: colors.cardBg,
                borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
                border: Border.all(color: colors.divider.withValues(alpha: 0.2)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    (averageRating?.toString() ?? '0.0'),
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: colors.textPrimary),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: List.generate(5, (i) => Icon(
                          i < (averageRating ?? 0).round() ? Icons.star_rounded : Icons.star_outline_rounded,
                          color: Colors.amber,
                          size: 16,
                        )),
                      ),
                      Text('${totalReviews ?? 0} ${AppStrings.rating}', style: TextStyle(fontSize: 11, color: colors.textLight)),
                    ],
                  ),
                ],
              ),
            ),
            const Spacer(),
            if (canAddReview)
              ElevatedButton.icon(
                onPressed: onAddReview,
                icon: const Icon(Icons.rate_review_rounded, size: 18),
                label: Text(AppStrings.rating),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.ten),
                ),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        ...reviews.take(3).map((review) => Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.sm + AppSpacing.xs),
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: colors.cardBg,
            borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
            border: Border.all(color: colors.divider.withValues(alpha: 0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: colors.primary.withValues(alpha: 0.15),
                    child: Text(
                      (review.patientName?.isNotEmpty == true ? review.patientName![0] : '?'),
                      style: TextStyle(fontSize: AppSpacing.bodyMedium, fontWeight: FontWeight.w600, color: colors.primary),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.ten),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(review.patientName ?? '', style: TextStyle(fontSize: AppSpacing.bodyMedium, fontWeight: FontWeight.w600, color: colors.textPrimary)),
                        Row(
                          children: List.generate(5, (i) => Icon(
                            i < review.rating.round() ? Icons.star_rounded : Icons.star_outline_rounded,
                            color: Colors.amber,
                            size: 14,
                          )),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    _formatDate(review.date),
                    style: TextStyle(fontSize: 11, color: colors.textLight),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.ten),
              Text(review.comment ?? '', style: TextStyle(fontSize: AppSpacing.caption, color: colors.textSecondary, height: 1.5)),
              if ((review.likesCount ?? 0) > 0) ...[
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Icon(Icons.thumb_up_rounded, size: 14, color: colors.textLight),
                    const SizedBox(width: AppSpacing.xs),
                    Text('${review.likesCount ?? 0}', style: TextStyle(fontSize: AppSpacing.bodySmall, color: colors.textLight)),
                  ],
                ),
              ],
            ],
          ),
        )),
      ],
    );
  }

  String _formatDate(String? dateStr) {
    final date = dateStr != null ? DateTime.tryParse(dateStr) : null;
    if (date == null) return '';
    final diff = DateTime.now().difference(date);
    if (diff.inDays == 0) return AppStrings.today;
    if (diff.inDays == 1) return AppStrings.yesterday;
    if (diff.inDays < 7) return '${AppStrings.since} ${diff.inDays} ${AppStrings.daysAgo}';
    if (diff.inDays < 30) return '${AppStrings.since} ${(diff.inDays / 7).round()} ${AppStrings.weeksAgo}';
    return '${AppStrings.since} ${(diff.inDays / 30).round()} ${AppStrings.monthAgo}';
  }
}

