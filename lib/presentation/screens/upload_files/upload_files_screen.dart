import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_routes.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/domain/entities/file_entity.dart';
import 'package:clinic_management_app/presentation/blocs/file/file_bloc.dart';
import 'package:clinic_management_app/presentation/blocs/file/file_event.dart';
import 'package:clinic_management_app/presentation/blocs/file/file_state.dart';
import 'package:clinic_management_app/presentation/widgets/animated_card.dart';
import 'package:clinic_management_app/presentation/widgets/app_shell.dart';
import 'package:clinic_management_app/presentation/widgets/skeleton/skeleton.dart';
import 'widgets/uf_recent_upload_item.dart';
import 'widgets/uf_security_card.dart';
import 'widgets/uf_section_header.dart';

class UploadFilesScreen extends StatefulWidget {
  const UploadFilesScreen({super.key});

  @override
  State<UploadFilesScreen> createState() => _UploadFilesScreenState();
}

class _UploadFilesScreenState extends State<UploadFilesScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<FileBloc>().add(const FileLoadAll());
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final max = _scrollController.position.maxScrollExtent;
    final current = _scrollController.position.pixels;
    if (current >= max - 200) {
      final state = context.read<FileBloc>().state;
      if (state is FileLoaded && !state.isLoadingMore && state.hasMore) {
        context.read<FileBloc>().add(FileLoadMore(page: state.page + 1));
      }
    }
  }

  void _pickAndUpload() {
    // TODO: Integrate file_picker when added to dependencies
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('File picker coming soon')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return AppShell(
      useGlassAppBar: true,
      glassTitle: AppStrings.ufTitle,
      currentRoute: AppRoutes.uploadFiles,
      showParticleBg: true,
      body: BlocConsumer<FileBloc, FileState>(
        listener: (context, state) {
          if (state is FileUploadSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${state.file.originalName} ${AppStrings.ufProgressComplete}'),
                backgroundColor: colors.success,
              ),
            );
            context.read<FileBloc>().add(const FileLoadAll());
          }
          if (state is FileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: colors.error,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is FileLoading) {
            return const SkeletonList();
          }
          if (state is FileUploadProgress) {
            return _buildUploadProgress(context, state);
          }
          if (state is FileLoaded) {
            return _buildFileList(context, state.files);
          }
          if (state is FileError) {
            return _buildError(context, state.message);
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickAndUpload,
        backgroundColor: colors.primary,
        child: const Icon(Icons.add_rounded),
      ),
    );
  }

  Widget _buildUploadProgress(BuildContext context, FileUploadProgress state) {
    final colors = AppColors.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(state.fileName, style: TextStyle(color: colors.textPrimary, fontSize: AppSpacing.bodyLarge)),
            const SizedBox(height: AppSpacing.md),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: Container(
                height: 8,
                color: colors.skeletonBase,
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: state.progress,
                  child: Container(color: colors.primary),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text('${(state.progress * 100).round()}%', style: TextStyle(color: colors.textLight)),
          ],
        ),
      ),
    );
  }

  Widget _buildFileList(BuildContext context, List<FileEntity> files) {
    final colors = AppColors.of(context);
    if (files.isEmpty) {
      return RefreshIndicator(
        onRefresh: () async => context.read<FileBloc>().add(const FileLoadAll()),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.sm, AppSpacing.md, 80),
          children: [
            AnimatedCard(
              index: 0,
              child: Center(
                child: Column(
                  children: [
                    const SizedBox(height: 80),
                    Icon(Icons.cloud_upload_rounded, size: 64, color: colors.textLight),
                    const SizedBox(height: AppSpacing.md),
                    Text(AppStrings.dfNoFiles, style: TextStyle(color: colors.textPrimary, fontSize: AppSpacing.titleMedium)),
                    const SizedBox(height: AppSpacing.sm),
                    Text(AppStrings.dfNoFilesHint, style: TextStyle(color: colors.textLight), textAlign: TextAlign.center),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            const AnimatedCard(index: 1, child: UfSecurityCard()),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      );
    }
    final state = context.read<FileBloc>().state;
    final isLoadingMore = state is FileLoaded && state.isLoadingMore;
    return RefreshIndicator(
      onRefresh: () async => context.read<FileBloc>().add(const FileLoadAll()),
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.sm, AppSpacing.md, 80),
        itemCount: files.length + 1 + (isLoadingMore ? 1 : 0),
        itemBuilder: (_, i) {
          if (i == 0) {
            return Column(
              children: [
                 AnimatedCard(index: 0, child: UfSectionHeader(label: AppStrings.ufRecentUploadsLabel)),
                const SizedBox(height: AppSpacing.sm),
              ],
            );
          }
          final fileIdx = i - 1;
          if (fileIdx >= files.length) {
            return Column(
              children: [
                if (isLoadingMore)
                  const Padding(
                    padding: EdgeInsets.all(AppSpacing.md),
                    child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                  ),
                const SizedBox(height: AppSpacing.md),
                AnimatedCard(index: i, child: const UfSecurityCard()),
                const SizedBox(height: AppSpacing.xl),
              ],
            );
          }
          final file = files[fileIdx];
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: AnimatedCard(
              index: i,
              child: UfRecentUploadItem(
                icon: _iconForType(file.mimeType),
                iconColor: colors.primary,
                fileName: file.originalName,
                subtitle: file.sizeFormatted,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildError(BuildContext context, String message) {
    final colors = AppColors.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline_rounded, size: 48, color: colors.error),
            const SizedBox(height: AppSpacing.md),
            Text(message, style: TextStyle(color: colors.error)),
            const SizedBox(height: AppSpacing.md),
            TextButton.icon(
              onPressed: () => context.read<FileBloc>().add(const FileLoadAll()),
              icon: const Icon(Icons.refresh_rounded),
              label: Text(AppStrings.retry),
            ),
          ],
        ),
      ),
    );
  }

  IconData _iconForType(String mimeType) {
    if (mimeType.contains('pdf')) return Icons.picture_as_pdf_rounded;
    if (mimeType.contains('image') || mimeType.contains('jpg') || mimeType.contains('jpeg') || mimeType.contains('png')) {
      return Icons.image_rounded;
    }
    if (mimeType.contains('dicom') || mimeType.contains('dcm')) return Icons.medical_services_rounded;
    return Icons.description_rounded;
  }
}
