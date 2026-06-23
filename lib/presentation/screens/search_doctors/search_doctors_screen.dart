import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clinic_management_app/core/constants/app_routes.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/domain/entities/doctor_entity.dart';
import 'package:clinic_management_app/presentation/blocs/doctor/doctor_bloc.dart';
import 'package:clinic_management_app/presentation/blocs/doctor/doctor_event.dart';
import 'package:clinic_management_app/presentation/blocs/doctor/doctor_state.dart';
import 'package:clinic_management_app/presentation/screens/search_doctors/widgets/sd_doctor_card.dart';
import 'package:clinic_management_app/presentation/screens/search_failure/widgets/sf_icon_section.dart';
import 'package:clinic_management_app/presentation/screens/search_failure/widgets/sf_content_card.dart';
import 'package:clinic_management_app/presentation/screens/search_failure/widgets/sf_actions.dart';
import 'package:clinic_management_app/presentation/widgets/skeleton/skeleton.dart';

class SearchDoctorsScreen extends StatefulWidget {
  const SearchDoctorsScreen({super.key});

  @override
  State<SearchDoctorsScreen> createState() => _SearchDoctorsScreenState();
}

class _SearchDoctorsScreenState extends State<SearchDoctorsScreen> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  Timer? _searchDebounce;
  String _query = '';
  String _selectedFilter = AppStrings.sdFilterAll;
  bool _showAllDoctors = false;

  static final _filters = [
    AppStrings.sdFilterAll,
    AppStrings.sdFilterCardiology,
    AppStrings.sdFilterNeurology,
    AppStrings.sdFilterDental,
  ];

  @override
  void initState() {
    super.initState();
    context.read<DoctorBloc>().add(DoctorLoadAll());
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      final state = context.read<DoctorBloc>().state;
      if (state is DoctorLoaded && state.hasMore && !state.isLoadingMore) {
        context.read<DoctorBloc>().add(DoctorLoadMore());
      }
    }
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  List<DoctorEntity> _filterDoctors(List<DoctorEntity> doctors) {
    return doctors.where((d) {
      final matchesSearch = _query.isEmpty ||
          d.name.contains(_query) ||
          d.specialty.contains(_query);
      final matchesFilter = _selectedFilter == AppStrings.sdFilterAll ||
          d.specialty.contains(_selectedFilter);
      return matchesSearch && matchesFilter;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Scaffold(
      backgroundColor: colors.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(colors),
            Expanded(
              child: BlocBuilder<DoctorBloc, DoctorState>(
                builder: (context, state) {
                  if (state is DoctorLoading && !_showAllDoctors) {
                    _showAllDoctors = true;
                    return Center(
                      child: CircularProgressIndicator(
                        color: colors.primary,
                      ),
                    );
                  }
                  if (state is DoctorLoaded || state is DoctorLoading) {
                    final doctors = state is DoctorLoaded
                        ? state.doctors
                        : <DoctorEntity>[];
                    final filtered = _filterDoctors(doctors);

                    if (state is DoctorLoading && doctors.isEmpty) {
                      return const SkeletonList();
                    }
                    final isLoadingMore = state is DoctorLoaded && state.isLoadingMore;

                    if (filtered.isEmpty && !isLoadingMore) {
                      return SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.md, AppSpacing.bottomNavHeight),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSearchSection(colors),
                            const SizedBox(height: AppSpacing.sm + AppSpacing.xs),
                            _buildFilterChips(colors),
                            const SizedBox(height: AppSpacing.md),
                            _buildResultsCount(0, colors),
                            const SizedBox(height: AppSpacing.sm + AppSpacing.xs),
                            _buildEmptyState(colors),
                          ],
                        ),
                      );
                    }
                    return Column(
                      children: [
                        _buildSearchSection(colors),
                        const SizedBox(height: AppSpacing.sm + AppSpacing.xs),
                        _buildFilterChips(colors),
                        const SizedBox(height: AppSpacing.md),
                        _buildResultsCount(filtered.length, colors),
                        const SizedBox(height: AppSpacing.sm + AppSpacing.xs),
                        Expanded(
                          child: ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.only(bottom: AppSpacing.bottomNavHeight),
                            itemCount: filtered.length + (isLoadingMore ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index == filtered.length) {
                                return const Padding(
                                  padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                                  child: Center(child: CircularProgressIndicator()),
                                );
                              }
                              return Padding(
                                padding: const EdgeInsets.only(bottom: AppSpacing.sm + AppSpacing.xs),
                                child: SdDoctorCard(
                                  doctor: filtered[index],
                                  onBook: () => Navigator.pushNamed(
                                    context,
                                    AppRoutes.userBooking,
                                    arguments: filtered[index].id,
                                  ),
                                  onChat: () {},
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  }
                  if (state is DoctorError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SfIconSection(),
                            const SizedBox(height: AppSpacing.xl),
                            SfContentCard(
                              title: 'فَشِلَتْ عَمَلِيَّةُ البَحْثِ',
                              message: state.message,
                            ),
                            const SizedBox(height: AppSpacing.xl),
                            SfActions(
                              onRetry: () => context.read<DoctorBloc>().add(DoctorLoadAll()),
                              onBack: () => Navigator.pop(context),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(AppColorSet colors) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      height: 64,
      decoration: BoxDecoration(
        color: colors.scaffoldBg.withValues(alpha: 0.4),
        border: Border(
          bottom: BorderSide(color: Colors.white.withValues(alpha: 0.06)),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_rounded),
            color: colors.primary,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              AppStrings.sdTitle,
              style: TextStyle(
                fontSize: AppSpacing.titleError,
                fontWeight: FontWeight.w700,
                color: colors.primary,
              ),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert_rounded),
            color: colors.divider,
          ),
        ],
      ),
    );
  }

  Widget _buildSearchSection(AppColorSet colors) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            ),
            child: TextField(
              controller: _searchController,
              style: TextStyle(
                fontSize: AppSpacing.bodyLarge,
                fontWeight: FontWeight.w400,
                color: colors.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: AppStrings.sdSearchHint,
                hintStyle: TextStyle(
                  color: colors.textLight,
                ),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: colors.textLight,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onChanged: (value) {
                _searchDebounce?.cancel();
                _searchDebounce = Timer(const Duration(milliseconds: 200), () {
                  setState(() => _query = value);
                });
              },
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm + AppSpacing.xs),
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: colors.cardBg.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
            border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
          ),
          child: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.filter_list_rounded),
            color: colors.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChips(AppColorSet colors) {
    return SizedBox(
      height: 32,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final isSelected = _selectedFilter == filter;
          return GestureDetector(
            onTap: () => setState(() => _selectedFilter = filter),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              decoration: BoxDecoration(
                color: isSelected
                    ? colors.primaryDark
                    : colors.cardBg.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(9999),
                border: isSelected
                    ? null
                    : Border.all(color: Colors.white.withValues(alpha: 0.05)),
              ),
              child: Center(
                child: Text(
                  filter,
                  style: TextStyle(
                    fontSize: AppSpacing.bodyMedium,
                    fontWeight: FontWeight.w500,
                    color: isSelected
                        ? colors.primaryLight
                        : colors.divider,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildResultsCount(int count, AppColorSet colors) {
    return Text(
      '${AppStrings.sdResultsCount} $count ${AppStrings.sdDoctor}',
      style: TextStyle(
        fontSize: AppSpacing.bodyMedium,
        fontWeight: FontWeight.w500,
        color: colors.divider,
      ),
    );
  }

  Widget _buildEmptyState(AppColorSet colors) {
    return Padding(
      padding: const EdgeInsets.only(top: 48),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 64,
              color: colors.textLight.withValues(alpha: 0.5),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'لم يتم العثور على أطباء',
              style: TextStyle(
                fontSize: AppSpacing.bodyLarge,
                fontWeight: FontWeight.w500,
                color: colors.textLight,
              ),
            ),
          ],
        ),
      ),
    );
  }


}
