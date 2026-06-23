import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';
import 'package:clinic_management_app/core/constants/app_icons.dart';

class UfRecentUploadItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String fileName;
  final String subtitle;
  final double opacity;

  const UfRecentUploadItem({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.fileName,
    required this.subtitle,
    this.opacity = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Opacity(
      opacity: opacity,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: colors.cardBg.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: colors.cardBg,
                borderRadius: BorderRadius.circular(AppSpacing.sm),
              ),
              child: Icon(icon, size: AppSpacing.iconSize, color: iconColor),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fileName,
                    style: TextStyle(fontSize: AppSpacing.bodyLarge, color: colors.textPrimary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: AppSpacing.bodySmall, fontWeight: FontWeight.w600, color: colors.textLight),
                  ),
                ],
              ),
            ),
            Icon(AppIcons.checkCircle, size: AppSpacing.iconSize, color: colors.primary),
          ],
        ),
      ),
    );
  }
}
