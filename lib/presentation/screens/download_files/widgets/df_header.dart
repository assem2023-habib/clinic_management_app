import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/presentation/blocs/download_file/download_file_bloc.dart';
import 'package:clinic_management_app/presentation/blocs/download_file/download_file_event.dart';

class DfHeader extends StatefulWidget {
  const DfHeader({super.key});

  @override
  State<DfHeader> createState() => _DfHeaderState();
}

class _DfHeaderState extends State<DfHeader> {
  final _searchController = TextEditingController();
  String _activeCategory = 'all';

  static final _categories = [
    ('all', AppStrings.dfCategoryAll),
    ('report', AppStrings.dfCategoryReports),
    ('lab', AppStrings.dfCategoryLab),
    ('imaging', AppStrings.dfCategoryImaging),
    ('billing', AppStrings.dfCategoryBilling),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
          decoration: BoxDecoration(
            color: colors.cardBg.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
            border: Border.all(color: colors.divider.withValues(alpha: 0.08)),
          ),
          child: Row(
            children: [
              Icon(Icons.search_rounded, color: colors.textLight, size: AppSpacing.iconMedium),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) => context.read<DownloadFileBloc>().add(DownloadFileSearch(value)),
                  decoration: InputDecoration(
                    hintText: AppStrings.dfSearchHint,
                    hintStyle: TextStyle(color: colors.textLight.withValues(alpha: 0.5), fontSize: AppSpacing.bodyMedium),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  style: TextStyle(fontSize: AppSpacing.bodyMedium, color: colors.textPrimary),
                ),
              ),
              InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  _searchController.clear();
                  context.read<DownloadFileBloc>().add(const DownloadFileSearch(''));
                },
                child: Icon(Icons.close_rounded, color: colors.textLight, size: AppSpacing.iconSmall),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          height: 36,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
            itemCount: _categories.length,
            separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
            itemBuilder: (_, index) {
              final (key, label) = _categories[index];
              final isActive = _activeCategory == key;
              return GestureDetector(
                onTap: () {
                  setState(() => _activeCategory = key);
                  context.read<DownloadFileBloc>().add(DownloadFileFilterCategory(key));
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs + 2),
                  decoration: BoxDecoration(
                    color: isActive ? colors.primary.withValues(alpha: 0.15) : colors.cardBg.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isActive ? colors.primary.withValues(alpha: 0.3) : colors.divider.withValues(alpha: 0.08),
                    ),
                  ),
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                      color: isActive ? colors.primary : colors.textSecondary,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
