import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';

class RatingActionCard extends StatelessWidget {
  final VoidCallback? onWriteReview;

  const RatingActionCard({super.key, this.onWriteReview});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.primaryDark,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: AppSpacing.xxl,
            height: AppSpacing.xxl,
            decoration: BoxDecoration(
              color: colors.primary.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.rate_review_rounded, color: colors.primaryLight, size: 28),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            AppStrings.rating,
            style: TextStyle(fontSize: AppSpacing.bodyLarge, fontWeight: FontWeight.w600, color: Colors.white),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            AppStrings.reviewPrompt,
            style: TextStyle(fontSize: AppSpacing.bodySmall, color: Colors.white.withValues(alpha: 0.8)),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onWriteReview,
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.success,
                foregroundColor: colors.textPrimary,
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.ten),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                elevation: 0,
              ),
              child: Text(AppStrings.writeReview, style: const TextStyle(fontSize: AppSpacing.bodyMedium, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }
}
