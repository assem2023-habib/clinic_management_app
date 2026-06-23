import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_routes.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/presentation/blocs/download_file/download_file_bloc.dart';
import 'package:clinic_management_app/presentation/blocs/download_file/download_file_event.dart';
import 'package:clinic_management_app/presentation/blocs/download_file/download_file_state.dart';
import 'package:clinic_management_app/presentation/screens/download_files/widgets/df_empty_state.dart';
import 'package:clinic_management_app/presentation/screens/download_files/widgets/df_file_card.dart';
import 'package:clinic_management_app/presentation/screens/download_files/widgets/df_header.dart';
import 'package:clinic_management_app/presentation/widgets/animated_card.dart';
import 'package:clinic_management_app/presentation/widgets/app_shell.dart';
import 'package:clinic_management_app/presentation/widgets/skeleton/skeleton.dart';
import 'package:clinic_management_app/core/constants/app_icons.dart';

class DownloadFilesScreen extends StatefulWidget {
  const DownloadFilesScreen({super.key});

  @override
  State<DownloadFilesScreen> createState() => _DownloadFilesScreenState();
}

class _DownloadFilesScreenState extends State<DownloadFilesScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<DownloadFileBloc>().add(const DownloadFileLoadAll());
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
      final state = context.read<DownloadFileBloc>().state;
      if (state is DownloadFileLoaded && !state.isLoadingMore && state.hasMore) {
        context.read<DownloadFileBloc>().add(DownloadFileLoadMore(page: state.page + 1));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return AppShell(
      title: AppStrings.dfTitle,
      currentRoute: AppRoutes.downloadFiles,
      body: BlocBuilder<DownloadFileBloc, DownloadFileState>(
        builder: (context, state) {
          if (state is DownloadFileLoading) return const SkeletonList();
          if (state is DownloadFileLoaded) {
            if (state.files.isEmpty) return const DfEmptyState();
            return RefreshIndicator(
              onRefresh: () async => context.read<DownloadFileBloc>().add(const DownloadFileLoadAll()),
              child: ListView.separated(
                controller: _scrollController,
                padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.md, AppSpacing.md, AppSpacing.lg),
                itemCount: state.files.length + 1 + (state.isLoadingMore ? 1 : 0),
                separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
                itemBuilder: (context, index) {
                  if (index == 0) return const DfHeader();
                  final fileIdx = index - 1;
                  if (fileIdx >= state.files.length) {
                    return const Padding(
                      padding: EdgeInsets.all(AppSpacing.md),
                      child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                    );
                  }
                  final file = state.files[fileIdx];
                  return AnimatedCard(index: fileIdx, child: DfFileCard(file: file));
                },
              ),
            );
          }
          if (state is DownloadFileError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(AppIcons.errorOutline, size: 48, color: colors.error),
                    const SizedBox(height: AppSpacing.md),
                    Text(state.message, style: TextStyle(color: colors.error)),
                    const SizedBox(height: AppSpacing.md),
                    TextButton.icon(
                      onPressed: () => context.read<DownloadFileBloc>().add(const DownloadFileLoadAll()),
                      icon: const Icon(AppIcons.refresh),
                      label: Text(AppStrings.retry),
                    ),
                  ],
                ),
              ),
            );
          }
          return const SkeletonList();
        },
      ),
    );
  }
}
