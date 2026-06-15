import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';

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
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: colors.cardBg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 24, color: iconColor),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fileName,
                    style: TextStyle(fontSize: 16, color: colors.textPrimary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: colors.textLight),
                  ),
                ],
              ),
            ),
            Icon(Icons.check_circle_rounded, size: 24, color: colors.primary),
          ],
        ),
      ),
    );
  }
}
