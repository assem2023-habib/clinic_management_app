import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/domain/entities/download_file_entity.dart';
import 'package:clinic_management_app/presentation/blocs/download_file/download_file_bloc.dart';
import 'package:clinic_management_app/presentation/blocs/download_file/download_file_event.dart';
import 'package:clinic_management_app/presentation/screens/download_files/widgets/df_progress_indicator.dart';
import 'package:intl/intl.dart';

class DfFileCard extends StatelessWidget {
  final DownloadFileEntity file;

  const DfFileCard({super.key, required this.file});

  IconData _fileIcon(String type) {
    return switch (type.toUpperCase()) {
      'PDF' => Icons.picture_as_pdf_rounded,
      'JPG' || 'PNG' => Icons.image_rounded,
      'DCM' => Icons.medical_services_rounded,
      _ => Icons.insert_drive_file_rounded,
    };
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final dateStr = DateFormat('yyyy/MM/dd').format(file.date);

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
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: _statusColor(colors).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.sm),
                ),
                child: Icon(_fileIcon(file.type), color: _statusColor(colors), size: 22),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      file.name,
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: colors.textPrimary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${file.type.toUpperCase()}  •  ${file.sizeInMb.toStringAsFixed(1)} ${AppStrings.dfMb}  •  $dateStr',
                      style: TextStyle(fontSize: 11, color: colors.textSecondary),
                    ),
                  ],
                ),
              ),
              _buildTrailing(context, colors),
            ],
          ),
          if (file.status == DownloadStatus.downloading) ...[
            const SizedBox(height: AppSpacing.sm),
            DfProgressLabel(progress: file.progress, displayStatus: DownloadStatus.downloading),
          ],
        ],
      ),
    );
  }

  Widget _buildTrailing(BuildContext context, AppColorSet colors) {
    switch (file.status) {
      case DownloadStatus.none:
        return Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
            onTap: () => context.read<DownloadFileBloc>().add(DownloadFileStart(file.id)),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs + 2),
              decoration: BoxDecoration(
                color: colors.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.download_rounded, size: 16, color: colors.primary),
                  const SizedBox(width: 4),
                  Text(AppStrings.dfDownload, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: colors.primary)),
                ],
              ),
            ),
          ),
        );
      case DownloadStatus.completed:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle_rounded, size: 18, color: colors.success),
            const SizedBox(width: 4),
            Text(AppStrings.dfDownloaded, style: TextStyle(fontSize: 11, color: colors.success)),
          ],
        );
      case DownloadStatus.error:
        return Icon(Icons.error_outline_rounded, size: 20, color: colors.error);
      default:
        return const SizedBox.shrink();
    }
  }

  Color _statusColor(AppColorSet colors) {
    return switch (file.type.toUpperCase()) {
      'PDF' => colors.primary,
      'JPG' || 'PNG' => const Color(0xFFF59E0B),
      'DCM' => const Color(0xFF8B5CF6),
      _ => colors.textLight,
    };
  }
}
