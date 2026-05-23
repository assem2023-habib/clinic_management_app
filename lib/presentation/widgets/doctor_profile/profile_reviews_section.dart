import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/domain/entities/review_entity.dart';

class ProfileReviewsSection extends StatelessWidget {
  final List<ReviewEntity> reviews;
  final double averageRating;
  final int totalReviews;
  final bool canAddReview;
  final VoidCallback? onAddReview;

  const ProfileReviewsSection({
    super.key,
    required this.reviews,
    required this.averageRating,
    required this.totalReviews,
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
            Text('التقييمات', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: colors.textPrimary)),
            TextButton(
              onPressed: () {},
              child: Text('عرض الكل', style: TextStyle(color: colors.primary)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: colors.cardBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colors.divider.withValues(alpha: 0.2)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    averageRating.toString(),
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: colors.textPrimary),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: List.generate(5, (i) => Icon(
                          i < averageRating.round() ? Icons.star_rounded : Icons.star_outline_rounded,
                          color: Colors.amber,
                          size: 16,
                        )),
                      ),
                      Text('$totalReviews تقييم', style: TextStyle(fontSize: 11, color: colors.textLight)),
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
                label: const Text('تقييم'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        ...reviews.take(3).map((review) => Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colors.cardBg,
            borderRadius: BorderRadius.circular(16),
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
                      review.patientName.isNotEmpty ? review.patientName[0] : '?',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: colors.primary),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(review.patientName, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: colors.textPrimary)),
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
              const SizedBox(height: 10),
              Text(review.comment, style: TextStyle(fontSize: 13, color: colors.textSecondary, height: 1.5)),
              if (review.likesCount > 0) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.thumb_up_rounded, size: 14, color: colors.textLight),
                    const SizedBox(width: 4),
                    Text('${review.likesCount}', style: TextStyle(fontSize: 12, color: colors.textLight)),
                  ],
                ),
              ],
            ],
          ),
        )),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inDays == 0) return 'اليوم';
    if (diff.inDays == 1) return 'أمس';
    if (diff.inDays < 7) return 'منذ ${diff.inDays} أيام';
    if (diff.inDays < 30) return 'منذ ${(diff.inDays / 7).round()} أسابيع';
    return 'منذ ${(diff.inDays / 30).round()} شهر';
  }
}
