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

class DownloadFilesScreen extends StatefulWidget {
  const DownloadFilesScreen({super.key});

  @override
  State<DownloadFilesScreen> createState() => _DownloadFilesScreenState();
}

class _DownloadFilesScreenState extends State<DownloadFilesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<DownloadFileBloc>().add(const DownloadFileLoadAll());
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
                padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.md, AppSpacing.md, AppSpacing.lg),
                itemCount: state.files.length + 1,
                separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
                itemBuilder: (context, index) {
                  if (index == 0) return const DfHeader();
                  final file = state.files[index - 1];
                  return AnimatedCard(index: index - 1, child: DfFileCard(file: file));
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
                    Icon(Icons.error_outline_rounded, size: 48, color: colors.error),
                    const SizedBox(height: AppSpacing.md),
                    Text(state.message, style: TextStyle(color: colors.error)),
                    const SizedBox(height: AppSpacing.md),
                    TextButton.icon(
                      onPressed: () => context.read<DownloadFileBloc>().add(const DownloadFileLoadAll()),
                      icon: const Icon(Icons.refresh_rounded),
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
