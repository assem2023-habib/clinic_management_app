import 'package:clinic_management_app/core/constants/app_icons.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';

class UfActiveUploadCard extends StatelessWidget {
  final String fileName;
  final String fileSize;
  final double progress;
  final int remainingSeconds;
  final VoidCallback? onCancel;

  const UfActiveUploadCard({
    super.key,
    required this.fileName,
    required this.fileSize,
    required this.progress,
    required this.remainingSeconds,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.cardBg.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: colors.cardBorder,
                  borderRadius: BorderRadius.circular(AppSpacing.sm),
                  border: Border.all(
                    color: colors.mint.withValues(alpha: 0.2),
                  ),
                ),
                child: Icon(
                  AppIcons.description,
                  size: 32,
                  color: colors.mint,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fileName,
                      style: TextStyle(
                        fontSize: AppSpacing.titleError,
                        fontWeight: FontWeight.w600,
                        color: colors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      '$fileSize • ${AppStrings.ufProcessing}',
                      style: TextStyle(
                        fontSize: AppSpacing.bodyMedium,
                        color: colors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Text(
                '${progress.round()}% ${AppStrings.ufProgressComplete}',
                style: TextStyle(
                  fontSize: AppSpacing.bodySmall,
                  fontWeight: FontWeight.w700,
                  color: colors.mint,
                ),
              ),
              const Spacer(),
              Text(
                '${AppStrings.ufRemaining} ${remainingSeconds}s',
                  style: TextStyle(
                    fontSize: AppSpacing.bodySmall,
                    color: colors.textMuted,
                  ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: Container(
              height: 8,
              color: colors.surfaceDark,
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: progress / 100,
                child: Container(
                  decoration: BoxDecoration(
                    color: colors.mint,
                    boxShadow: [
                      BoxShadow(
                        color: colors.emerald.withValues(alpha: 0.4),
                        blurRadius: 15,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Align(
            alignment: Alignment.centerLeft,
            child: OutlinedButton(
              onPressed: onCancel,
              style: OutlinedButton.styleFrom(
                foregroundColor: colors.textMuted,
                side: BorderSide(
                  color: Colors.white.withValues(alpha: 0.15),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
              child:  Text(AppStrings.ufCancelUpload),
            ),
          ),
        ],
      ),
    );
  }
}
