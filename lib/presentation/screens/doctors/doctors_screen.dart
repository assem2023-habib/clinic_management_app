import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/core/constants/app_routes.dart';
import 'package:clinic_management_app/core/utils/app_toast.dart';
import 'package:clinic_management_app/domain/entities/doctor_entity.dart';
import 'package:clinic_management_app/domain/entities/specialization_entity.dart';
import 'package:clinic_management_app/domain/entities/user_role.dart';
import 'package:clinic_management_app/domain/repositories/specialization_repository.dart';
import 'package:clinic_management_app/presentation/blocs/auth/auth_cubit.dart';
import 'package:clinic_management_app/presentation/blocs/doctor/doctor_bloc.dart';
import 'package:clinic_management_app/presentation/blocs/doctor/doctor_event.dart';
import 'package:clinic_management_app/presentation/blocs/doctor/doctor_state.dart';
import 'package:clinic_management_app/presentation/widgets/doctor_form_dialog.dart';
import 'package:clinic_management_app/presentation/widgets/doctor_glass_card.dart';
import 'package:clinic_management_app/presentation/widgets/app_shell.dart';

class DoctorsScreen extends StatefulWidget {
  const DoctorsScreen({super.key});

  @override
  State<DoctorsScreen> createState() => _DoctorsScreenState();
}

class _DoctorsScreenState extends State<DoctorsScreen> {
  final _searchController = TextEditingController();
  final _searchFocus = FocusNode();
  Timer? _searchDebounce;
  bool _isSearchFocused = false;
  String? _selectedSpecializationId;
  List<SpecializationEntity> _specializations = [];

  @override
  void initState() {
    super.initState();
    context.read<DoctorBloc>().add(DoctorLoadAll());
    _searchFocus.addListener(() => setState(() => _isSearchFocused = _searchFocus.hasFocus));
    _loadSpecializations();
  }

  Future<void> _loadSpecializations() async {
    try {
      final repo = RepositoryProvider.of<SpecializationRepository>(context);
      final specs = await repo.getAllSpecializations();
      if (mounted) setState(() => _specializations = specs);
    } catch (_) {}
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  void _openSheet(AppColorSet colors, DoctorEntity doctor) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _buildBottomSheet(colors, doctor),
    );
  }

  Widget _buildBottomSheet(AppColorSet colors, DoctorEntity doctor) {
    final bottom = MediaQuery.of(context).padding.bottom + AppSpacing.md;
    const radius28 = BorderRadius.vertical(top: Radius.circular(28));
    return Container(
      decoration: BoxDecoration(
        color: colors.surfaceDark,
        borderRadius: radius28,
        border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.08))),
      ),
      padding: EdgeInsets.only(bottom: bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 5,
            margin: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: colors.textLight.withValues(alpha: 0.28),
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          Padding(
            padding: AppSpacing.listPadding,
            child: Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [colors.primaryDark, colors.secondary],
                    ),
                    borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
                  ),
                  child: const Icon(Icons.person, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'الخيارات المتاحة لـ',
                      style: TextStyle(
                        fontSize: 11,
                        color: colors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      'د. ${doctor.name}',
                      style: TextStyle(
                        fontSize: AppSpacing.bodyLarge,
                        fontWeight: FontWeight.w700,
                        color: colors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          _sheetOption(
            colors,
            icon: Icons.visibility_rounded,
            label: 'عرض الملف',
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.doctorProfile, arguments: doctor.id);
            },
          ),
          _sheetOption(
            colors,
            icon: Icons.edit_rounded,
            label: AppStrings.edit,
            onTap: () {
              Navigator.pop(context);
              _showDoctorForm(context, doctor: doctor);
            },
          ),
          _sheetOption(
            colors,
            icon: Icons.delete_rounded,
            label: AppStrings.delete,
            isDanger: true,
            onTap: () {
              Navigator.pop(context);
              _showDeleteConfirmDialog(colors, doctor);
            },
          ),
          const SizedBox(height: AppSpacing.sm),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: double.infinity,
              margin: AppSpacing.listPadding,
              padding: const EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
              ),
              child: Text(
                AppStrings.cancel,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: AppSpacing.bodyMedium,
                  fontWeight: FontWeight.w600,
                  color: colors.textSecondary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sheetOption(
    AppColorSet colors, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isDanger = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: AppSpacing.listPadding,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 15),
        child: Row(
          children: [
            Icon(icon, size: 22, color: isDanger ? colors.error : colors.textPrimary),
            const SizedBox(width: AppSpacing.md),
            Text(
              label,
              style: TextStyle(
                fontSize: AppSpacing.bodyLarge,
                fontWeight: FontWeight.w500,
                color: isDanger ? colors.error : colors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmDialog(AppColorSet colors, DoctorEntity doctor) {
    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setDialogState) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: colors.surfaceDark,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      color: colors.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: colors.error.withValues(alpha: 0.2)),
                    ),
                    child: Icon(Icons.delete_forever_rounded, size: 30, color: colors.error),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'تأكيد الحذف',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'هل أنت متأكد من حذف ملف\nد. ${doctor.name}؟\nلا يمكن التراجع عن هذا الإجراء.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: AppSpacing.bodyMedium,
                      height: 1.65,
                      color: colors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => Navigator.pop(ctx),
                          child: Container(
                            height: 48,
                            decoration: BoxDecoration(
                              color: colors.surfaceDark,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Center(
                              child: Text(
                                AppStrings.cancel,
                                style: TextStyle(
                                  fontSize: AppSpacing.bodyMedium,
                                  fontWeight: FontWeight.w700,
                                  color: colors.textSecondary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(ctx);
                            context.read<DoctorBloc>().add(DoctorDelete(doctor.id));
                            showAppToast(context, AppStrings.doctorDeleted);
                          },
                          child: Container(
                            height: 48,
                            decoration: BoxDecoration(
                              color: colors.error.withValues(alpha: 0.13),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: colors.error.withValues(alpha: 0.28)),
                            ),
                            child: Center(
                              child: Text(
                                AppStrings.delete,
                                style: TextStyle(
                                  fontSize: AppSpacing.bodyMedium,
                                  fontWeight: FontWeight.w700,
                                  color: colors.error,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showDoctorForm(BuildContext context, {DoctorEntity? doctor}) {
    showDialog(
      context: context,
      builder: (_) => DoctorFormDialog(doctor: doctor),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final role = context.watch<AuthCubit>().state.role;
    final canManage = role == UserRole.admin || role == UserRole.receptionist;

    return AppShell(
      showDrawer: true,
      extendBody: true,
      useGlassAppBar: true,
      glassTitle: 'البحث عن طبيب',
      showParticleBg: true,
      body: Column(
        children: [
          _buildSearchBar(colors),
          _buildCategoryChips(colors),
          Expanded(
            child: BlocBuilder<DoctorBloc, DoctorState>(
              builder: (context, state) {
                if (state is DoctorLoading) {
                  return const GlassSkeletonList();
                }
                if (state is DoctorLoaded) {
                  if (state.doctors.isEmpty) {
                    return _buildEmptyState(colors);
                  }
                  return _buildDoctorList(colors, state.doctors, canManage);
                }
                if (state is DoctorError) {
                  return Center(
                    child: Text(state.message, style: TextStyle(color: colors.error)),
                  );
                }
                return _buildEmptyState(colors);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: canManage
          ? FloatingActionButton(
              onPressed: () => _showDoctorForm(context),
              backgroundColor: colors.accent,
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }

  Widget _buildSearchBar(AppColorSet colors) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
      child: Focus(
        onFocusChange: (focused) => setState(() => _isSearchFocused = focused),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            color: colors.surfaceDark.withValues(alpha: 0.65),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: _isSearchFocused
                  ? colors.accent.withValues(alpha: 0.6)
                  : Colors.white.withValues(alpha: 0.06),
            ),
            boxShadow: _isSearchFocused
                ? [BoxShadow(
                    color: colors.accent.withValues(alpha: 0.15),
                    blurRadius: 16,
                    spreadRadius: 1,
                  )]
                : null,
          ),
          child: TextField(
            controller: _searchController,
            focusNode: _searchFocus,
            style: TextStyle(color: colors.textPrimary, fontSize: AppSpacing.bodyMedium),
            onChanged: (value) {
              _searchDebounce?.cancel();
              _searchDebounce = Timer(const Duration(milliseconds: 300), () {
                context.read<DoctorBloc>().add(DoctorSearch(value));
              });
              if (value.isNotEmpty) {
                setState(() => _selectedSpecializationId = null);
              }
            },
            decoration: InputDecoration(
              hintText: 'ابحث عن اسم الطبيب أو التخصص...',
              hintStyle: TextStyle(color: colors.textSecondary.withValues(alpha: 0.6), fontSize: AppSpacing.bodyMedium),
              prefixIcon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  _isSearchFocused ? Icons.search_rounded : Icons.search_rounded,
                  key: ValueKey(_isSearchFocused),
                  size: 22,
              color: _isSearchFocused
                  ? colors.accent
                  : colors.textSecondary.withValues(alpha: 0.6),
                ),
              ),
              suffixIcon: _searchController.text.isNotEmpty
                  ? GestureDetector(
                      onTap: () {
                        _searchController.clear();
                        context.read<DoctorBloc>().add(DoctorSearch(''));
                      },
                      child: Icon(Icons.close_rounded, size: AppSpacing.iconSmall, color: colors.textSecondary),
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChips(AppColorSet colors) {
    final chips = <_SpecChip>[
      _SpecChip(id: null, label: AppStrings.dpFilterAll),
      ..._specializations.map((s) => _SpecChip(id: s.id, label: s.nameAr)),
    ];

    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        itemCount: chips.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (_, i) {
          final chip = chips[i];
          final isActive = _selectedSpecializationId == chip.id;
          return GestureDetector(
            onTap: () {
              setState(() => _selectedSpecializationId = chip.id);
              context.read<DoctorBloc>().add(DoctorLoadAll(specializationId: chip.id));
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              decoration: BoxDecoration(
                  color: isActive
                      ? colors.accent.withValues(alpha: 0.15)
                      : Colors.white.withValues(alpha: 0.04),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isActive
                      ? colors.accent.withValues(alpha: 0.4)
                      : Colors.white.withValues(alpha: 0.06),
                ),
              ),
              child: Text(
                chip.label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                  color: isActive
                      ? colors.accent
                      : colors.textSecondary,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDoctorList(
      AppColorSet colors, List<DoctorEntity> doctors, bool canManage) {
    final role = context.watch<AuthCubit>().state.role;
    final isPatient = role == UserRole.patient;

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 100),
      itemCount: doctors.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (_, i) {
        final doctor = doctors[i];
        return DoctorGlassCard(
          doctor: doctor,
          animDelay: Duration(milliseconds: 80 * i),
          showSupervision: isPatient,
          onBook: canManage
              ? null
              : () => Navigator.pushNamed(
                  context, AppRoutes.userBooking, arguments: doctor.id),
          onMore: canManage
              ? () => _openSheet(colors, doctor)
              : null,
          onSupervisionRequest: isPatient
              ? () {
                  // TODO: Wire supervision request via SupervisionBloc
                  showAppToast(context, AppStrings.supervisionRequestSent);
                }
              : null,
        );
      },
    );
  }

  Widget _buildEmptyState(AppColorSet colors) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off_rounded, size: 56, color: colors.textSecondary.withValues(alpha: 0.4)),
          const SizedBox(height: AppSpacing.md),
          Text(
            AppStrings.noData,
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: colors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.bulletSize),
          Text(
            'جرّب البحث بكلمة مختلفة',
            style: TextStyle(fontSize: 13, color: colors.textSecondary.withValues(alpha: 0.6)),
          ),
        ],
      ),
    );
  }

}

class _SpecChip {
  final String? id;
  final String label;
  const _SpecChip({this.id, required this.label});
}

class GlassSkeletonList extends StatelessWidget {
  const GlassSkeletonList({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      itemCount: 3,
      itemBuilder: (_, i) => Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.md),
        child: Container(
          height: 280,
          decoration: BoxDecoration(
            color: colors.surfaceDark.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SkeletonContainer(width: 80, height: 80, borderRadius: 14),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SkeletonContainer(width: 60, height: 14),
                          const SizedBox(height: AppSpacing.sm),
                          SkeletonContainer(width: 140, height: 18),
                          const SizedBox(height: AppSpacing.bulletSize),
                          SkeletonContainer(width: 100, height: 14),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SkeletonContainer(width: 180, height: 14),
                const SizedBox(height: AppSpacing.sm),
                SkeletonContainer(width: double.infinity, height: 14),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SkeletonContainer extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;
  const SkeletonContainer({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: colors.surfaceDark,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}
