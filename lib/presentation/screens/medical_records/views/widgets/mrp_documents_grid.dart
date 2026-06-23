import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/core/constants/app_icons.dart';

class MrpDocumentCard extends StatelessWidget {
  final String title;
  final String subtitle;

  const MrpDocumentCard({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.surfaceDark.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 96,
            decoration: BoxDecoration(
              color: colors.cardBg,
              borderRadius: BorderRadius.circular(AppSpacing.sm),
            ),
            child: Center(
              child: Icon(
                AppIcons.description,
                size: 48,
                color: colors.surfaceDark,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm + AppSpacing.xs),
          Text(
            title,
            style: TextStyle(
              fontSize: AppSpacing.bodyMedium,
              fontWeight: FontWeight.w600,
              color: colors.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: AppSpacing.bodySmall,
              fontWeight: FontWeight.w500,
              color: colors.divider,
            ),
          ),
        ],
      ),
    );
  }
}

class MrpUploadButton extends StatelessWidget {
  final VoidCallback? onUpload;

  const MrpUploadButton({super.key, this.onUpload});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onUpload,
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: Colors.white.withValues(alpha: 0.15),
            width: 2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
          ),
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
        ),
        child: Column(
          children: [
            Icon(
              AppIcons.uploadFile,
              size: 32,
              color: colors.primary,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              AppStrings.mrUploadDocument,
              style: TextStyle(
                fontSize: AppSpacing.bodyMedium,
                fontWeight: FontWeight.w600,
                color: colors.textPrimary,
              ),
            ),
            Text(
              AppStrings.mrUploadHint,
              style: TextStyle(
                fontSize: AppSpacing.bodySmall,
                fontWeight: FontWeight.w500,
                color: colors.divider,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
