import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';
import 'package:clinic_management_app/domain/entities/download_file_entity.dart';

class DfProgressIndicator extends StatelessWidget {
  final double progress;
  final double height;

  const DfProgressIndicator({super.key, required this.progress, this.height = 6});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(height / 2),
      child: Stack(
        children: [
          Container(
            height: height,
            width: double.infinity,
            color: colors.divider.withValues(alpha: 0.15),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: height,
            width: MediaQuery.of(context).size.width * 0.5 * progress.clamp(0.0, 1.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colors.primary.withValues(alpha: 0.7),
                  colors.primary,
                ],
              ),
              borderRadius: BorderRadius.circular(height / 2),
            ),
          ),
        ],
      ),
    );
  }
}

class DfProgressLabel extends StatelessWidget {
  final double progress;
  final DownloadStatus displayStatus;

  const DfProgressLabel({super.key, required this.progress, required this.displayStatus});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final pct = (progress * 100).toInt();

    return Row(
      children: [
        Expanded(
          child: DfProgressIndicator(progress: progress),
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(
          displayStatus == DownloadStatus.downloading ? '$pct%' : '',
          style: TextStyle(fontSize: AppSpacing.bodySmall, fontWeight: FontWeight.w600, color: colors.primary),
        ),
      ],
    );
  }
}


