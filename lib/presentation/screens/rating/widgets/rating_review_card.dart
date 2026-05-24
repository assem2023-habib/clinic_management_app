import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/domain/entities/review_entity.dart';

class RatingReviewCard extends StatelessWidget {
  final ReviewEntity review;
  final bool isLiked;
  final VoidCallback? onToggleLike;
  final VoidCallback? onFlag;

  const RatingReviewCard({
    super.key,
    required this.review,
    this.isLiked = false,
    this.onToggleLike,
    this.onFlag,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final diff = DateTime.now().difference(review.date);
    final timeAgo = _formatTimeAgo(diff);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.cardBg.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(color: colors.divider.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: colors.primary.withValues(alpha: 0.15),
                backgroundImage: review.patientImage != null
                    ? NetworkImage(review.patientImage!)
                    : null,
                child: review.patientImage == null
                    ? Text(
                        review.patientName.isNotEmpty ? review.patientName[0] : '?',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: colors.primary),
                      )
                    : null,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.patientName,
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: colors.textPrimary),
                    ),
                    Text(
                      timeAgo,
                      style: TextStyle(fontSize: 12, color: colors.textSecondary),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(5, (i) {
                  final starIndex = i + 1;
                  final fill = starIndex <= review.rating.round();
                  return Padding(
                    padding: const EdgeInsets.only(left: 1),
                    child: Icon(
                      fill ? Icons.star_rounded : Icons.star_outline_rounded,
                      color: colors.primary,
                      size: 16,
                    ),
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            review.comment,
            style: TextStyle(fontSize: 14, color: colors.textSecondary, height: 1.6),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              GestureDetector(
                onTap: onToggleLike,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
                  decoration: BoxDecoration(
                    color: colors.divider.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppSpacing.sm),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isLiked ? Icons.thumb_up_rounded : Icons.thumb_up_outlined,
                        size: 14,
                        color: isLiked ? colors.primary : colors.textSecondary,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        '${review.likesCount + (isLiked && review.likesCount == 0 ? 1 : 0)}',
                        style: TextStyle(fontSize: 12, color: isLiked ? colors.primary : colors.textSecondary),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              GestureDetector(
                onTap: onFlag,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
                  decoration: BoxDecoration(
                    color: colors.divider.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppSpacing.sm),
                  ),
                  child: Icon(Icons.flag_outlined, size: 14, color: colors.textSecondary),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatTimeAgo(Duration diff) {
    if (diff.inDays == 0) return AppStrings.timeAgoTwoDays;
    if (diff.inDays == 1) return AppStrings.timeAgoYesterday;
    if (diff.inDays < 7) return '${AppStrings.timeAgoSince} ${diff.inDays} ${AppStrings.timeAgoDays}';
    if (diff.inDays < 30) return '${AppStrings.timeAgoSince} ${(diff.inDays / 7).round()} ${AppStrings.timeAgoWeeks}';
    if (diff.inDays < 365) return '${AppStrings.timeAgoSince} ${(diff.inDays / 30).round()} ${AppStrings.timeAgoMonth}';
    return '${AppStrings.timeAgoSince} ${(diff.inDays / 365).round()} ${AppStrings.timeAgoYear}';
  }
}
