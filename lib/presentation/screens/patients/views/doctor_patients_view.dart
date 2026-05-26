import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/domain/entities/patient_entity.dart';
import 'package:clinic_management_app/presentation/blocs/auth/auth_cubit.dart';
import 'package:clinic_management_app/presentation/blocs/patient/patient_bloc.dart';
import 'package:clinic_management_app/presentation/blocs/patient/patient_event.dart';
import 'package:clinic_management_app/presentation/blocs/patient/patient_state.dart';
import 'package:clinic_management_app/presentation/widgets/animated_card.dart';
import 'package:clinic_management_app/presentation/widgets/skeleton/skeleton.dart';

class DoctorPatientsView extends StatefulWidget {
  const DoctorPatientsView({super.key});

  @override
  State<DoctorPatientsView> createState() => _DoctorPatientsViewState();
}

class _DoctorPatientsViewState extends State<DoctorPatientsView> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  String _activeFilter = 'all';

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  List<PatientEntity> _filterPatients(List<PatientEntity> patients) {
    if (_activeFilter == 'all') {
      return patients;
    }
    final gender = _activeFilter == 'male' ? Gender.male : Gender.female;
    return patients.where((p) => p.gender == gender).toList();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final state = context.watch<AuthCubit>().state;
    final doctorName = state.userName ?? AppStrings.roleDoctor;

    return Column(
      children: [
        _buildHeader(colors, doctorName),
        Expanded(
          child: BlocBuilder<PatientBloc, PatientState>(
            builder: (context, state) {
              if (state is PatientLoading) return const SkeletonList();
              if (state is PatientLoaded) {
                final filtered = _filterPatients(state.patients);
                if (filtered.isEmpty) return _buildEmptyState(colors);
                return RefreshIndicator(
                  onRefresh: () async => context.read<PatientBloc>().add(PatientLoadAll()),
                  child: ListView.separated(
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.md, AppSpacing.lg),
                    itemCount: filtered.length + 1,
                    separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
                    itemBuilder: (context, index) {
                      if (index == 0) return _buildSearchAndFilters(colors);
                      final patient = filtered[index - 1];
                      return AnimatedCard(
                        index: index - 1,
                        child: _buildPatientCard(patient, colors),
                      );
                    },
                  ),
                );
              }
              if (state is PatientError) {
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
                        onPressed: () => context.read<PatientBloc>().add(PatientLoadAll()),
                        icon: const Icon(Icons.refresh_rounded),
                        label: Text(AppStrings.retry),
                      ),
                    ],
                  ),
                ),
              );
              }
              return _buildEmptyState(colors);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(AppColorSet colors, String doctorName) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.md, AppSpacing.md, AppSpacing.sm),
      decoration: BoxDecoration(
        color: colors.appBarBg.withValues(alpha: 0.7),
        border: Border(bottom: BorderSide(color: colors.divider.withValues(alpha: 0.1))),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: colors.primary.withValues(alpha: 0.2)),
              color: colors.primary.withValues(alpha: 0.1),
            ),
            child: Icon(Icons.people_rounded, color: colors.primary, size: 22),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.dpMyPatients,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: colors.textPrimary),
                ),
                const SizedBox(height: 2),
                Text(
                  AppStrings.dpUnderCareOf(doctorName),
                  style: TextStyle(fontSize: 12, color: colors.textSecondary),
                ),
              ],
            ),
          ),
          BlocBuilder<PatientBloc, PatientState>(
            builder: (context, state) {
              final count = state is PatientLoaded ? state.patients.length : 0;
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$count ${AppStrings.dpPatient}',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: colors.primary),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilters(AppColorSet colors) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.md),
      child: Column(
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
                Icon(Icons.search_rounded, color: colors.textLight, size: 22),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) => context.read<PatientBloc>().add(PatientSearch(value)),
                    decoration: InputDecoration(
                      hintText: AppStrings.dpSearchPatients,
                      hintStyle: TextStyle(color: colors.textLight.withValues(alpha: 0.5), fontSize: 14),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                    style: TextStyle(fontSize: 14, color: colors.textPrimary),
                  ),
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () => _searchController.clear(),
                  child: Icon(Icons.close_rounded, color: colors.textLight, size: 20),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
            child: Row(
              children: [
                _buildFilterChip(colors, AppStrings.dpFilterAll, 'all'),
                const SizedBox(width: AppSpacing.sm),
                _buildFilterChip(colors, AppStrings.dpFilterNew, 'new'),
                const SizedBox(width: AppSpacing.sm),
                _buildFilterChip(colors, AppStrings.dpFilterMale, 'male'),
                const SizedBox(width: AppSpacing.sm),
                _buildFilterChip(colors, AppStrings.dpFilterFemale, 'female'),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
      ),
    );
  }

  Widget _buildFilterChip(AppColorSet colors, String label, String filter) {
    final isActive = _activeFilter == filter;
    return GestureDetector(
      onTap: () => setState(() => _activeFilter = filter),
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
  }

  Widget _buildPatientCard(PatientEntity patient, AppColorSet colors) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.cardBg.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(color: colors.divider.withValues(alpha: 0.08)),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: patient.gender == Gender.male
                  ? colors.primary.withValues(alpha: 0.15)
                  : Colors.pink.withValues(alpha: 0.15),
            ),
            child: Icon(
              patient.gender == Gender.male ? Icons.male_rounded : Icons.female_rounded,
              color: patient.gender == Gender.male ? colors.primary : Colors.pink,
              size: 26,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  patient.name,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: colors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    _buildInfoChip(colors, Icons.calendar_today_rounded, '${patient.age} ${AppStrings.dpYear}'),
                    const SizedBox(width: AppSpacing.sm),
                    if (patient.bloodType != null)
                      _buildInfoChip(colors, Icons.water_drop_rounded, patient.bloodType!),
                    const SizedBox(width: AppSpacing.sm),
                    _buildInfoChip(colors, Icons.phone_rounded, patient.phone),
                  ],
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_left_rounded, color: colors.textLight, size: 22),
        ],
      ),
    );
  }

  Widget _buildInfoChip(AppColorSet colors, IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: colors.textLight),
        const SizedBox(width: 3),
        Text(
          text,
          style: TextStyle(fontSize: 11, color: colors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildEmptyState(AppColorSet colors) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.people_outline_rounded, size: 64, color: colors.textLight.withValues(alpha: 0.3)),
            const SizedBox(height: AppSpacing.md),
            Text(
              AppStrings.dpNoPatients,
              style: TextStyle(fontSize: 16, color: colors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              AppStrings.dpNoPatientsHint,
              style: TextStyle(fontSize: 13, color: colors.textLight),
            ),
          ],
        ),
      ),
    );
  }
}
