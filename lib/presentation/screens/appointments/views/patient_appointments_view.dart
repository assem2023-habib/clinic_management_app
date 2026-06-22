import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/domain/entities/appointment_entity.dart';
import 'package:clinic_management_app/presentation/blocs/appointment/appointment_bloc.dart';
import 'package:clinic_management_app/presentation/blocs/appointment/appointment_state.dart';
import 'package:clinic_management_app/presentation/widgets/appointments/appointment_card_skeleton.dart';
import 'package:clinic_management_app/presentation/widgets/appointments/appointment_options_sheet.dart';
import 'package:clinic_management_app/presentation/widgets/appointments/appointment_timeline_row.dart';
import 'package:clinic_management_app/presentation/widgets/appointments/month_divider.dart';

class PatientAppointmentsView extends StatefulWidget {
  const PatientAppointmentsView({super.key});

  @override
  State<PatientAppointmentsView> createState() => _PatientAppointmentsViewState();
}

class _PatientAppointmentsViewState extends State<PatientAppointmentsView> {
  final _searchCtrl = TextEditingController();
  final _focusNode = FocusNode();
  Timer? _searchDebounce;
  String _searchQuery = '';
  AppointmentStatus? _statusFilter;
  bool _showUpcoming = true;

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchCtrl.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppointmentBloc, AppointmentState>(
      builder: (context, state) {
        if (state is AppointmentLoading) {
          return _buildSkeleton();
        }
        if (state is AppointmentLoaded) {
          return _buildContent(state.appointments);
        }
        if (state is AppointmentError) {
          return Center(
            child: Text(state.message,
              style: TextStyle(color: AppColors.of(context).error, fontSize: AppSpacing.bodyMedium)),
          );
        }
        return _buildContent([]);
      },
    );
  }

  Widget _buildSkeleton() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.xl, AppSpacing.md, 100),
      itemCount: 5,
      itemBuilder: (_, i) => Padding(
        padding: EdgeInsets.only(top: i == 0 ? 0 : 12, bottom: 20),
        child: const AppointmentCardSkeleton(),
      ),
    );
  }

  Widget _buildContent(List<AppointmentEntity> all) {
    final c = AppColors.of(context);
    final now = DateTime.now();

    final filtered = all.where((a) {
      if (_showUpcoming) {
        final d = a.date ?? a.appointmentDate;
        if (d == null) return true;
        final dt = DateTime.tryParse(d);
        return dt == null || dt.isAfter(now.subtract(const Duration(days: 1)));
      } else {
        final d = a.date ?? a.appointmentDate;
        if (d == null) return false;
        final dt = DateTime.tryParse(d);
        return dt != null && dt.isBefore(now);
      }
    }).where((a) {
      if (_statusFilter == null) return true;
      return a.status == _statusFilter;
    }).where((a) {
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      final docName = (a.doctorName ?? a.doctor?.name ?? '').toLowerCase();
      final specialty = (a.doctor?.specialty ?? '').toLowerCase();
      return docName.contains(q) || specialty.contains(q);
    }).toList();

    _sortByDate(filtered);

    return Column(
      children: [
        _buildSearchBar(c),
        _buildTabRow(c),
        _buildFilterChips(c),
        Expanded(
          child: filtered.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.event_busy_rounded, size: AppSpacing.xxl,
                        color: c.textLight.withValues(alpha: 0.5)),
                      const SizedBox(height: 12),
                      Text(AppStrings.noAppointments, style: TextStyle(fontSize: 15, color: c.textLight)),
                    ],
                  ),
                )
              : _buildTimelineList(filtered),
        ),
      ],
    );
  }

  Widget _buildSearchBar(AppColorSet c) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.md, 14, AppSpacing.md, AppSpacing.sm),
      child: Container(
        height: 46,
        decoration: BoxDecoration(
          color: c.cardBg.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
        ),
        child: TextField(
          controller: _searchCtrl,
          focusNode: _focusNode,
          onChanged: (v) {
            _searchDebounce?.cancel();
            _searchDebounce = Timer(const Duration(milliseconds: 200), () {
              if (mounted) setState(() => _searchQuery = v);
            });
          },
          style: TextStyle(color: c.textPrimary, fontSize: AppSpacing.bodyMedium),
          decoration: InputDecoration(
            hintText: AppStrings.search,
            hintStyle: TextStyle(color: c.textLight.withValues(alpha: 0.7), fontSize: AppSpacing.bodyMedium),
            prefixIcon: Icon(Icons.search_rounded, size: AppSpacing.iconSmall,
              color: c.textLight.withValues(alpha: 0.7)),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: Icon(Icons.close, size: 18,
                      color: c.textLight.withValues(alpha: 0.7)),
                    onPressed: () { _searchCtrl.clear(); setState(() => _searchQuery = ''); },
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ),
    );
  }

  Widget _buildTabRow(AppColorSet c) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 6),
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: c.cardBg.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _showUpcoming = true),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: _showUpcoming ? c.primaryDark : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Text(AppStrings.upcomingAppts, style: TextStyle(fontSize: AppSpacing.bodyMedium, fontWeight: FontWeight.w600, color: c.textPrimary)),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _showUpcoming = false),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: !_showUpcoming ? c.primaryDark : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Text(AppStrings.previousVisits, style: TextStyle(fontSize: AppSpacing.bodyMedium, fontWeight: FontWeight.w600, color: c.textPrimary)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips(AppColorSet c) {
    const filters = <AppointmentStatus?>[null, AppointmentStatus.confirmed, AppointmentStatus.pending, AppointmentStatus.completed, AppointmentStatus.cancelled];
    const labels = [AppStrings.dpFilterAll, AppStrings.confirmedAppts, AppStrings.pendingAppointments, AppStrings.completedAppts, AppStrings.cancelledAppts];

    return Container(
      height: 40,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: AppSpacing.listPadding,
        itemCount: filters.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (_, i) {
          final active = _statusFilter == filters[i];
          return GestureDetector(
            onTap: () => setState(() => _statusFilter = active ? null : filters[i]),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: active ? c.primaryDark.withValues(alpha: 0.3) : c.cardBg.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: active ? c.primary.withValues(alpha: 0.4) : Colors.white.withValues(alpha: 0.06),
                ),
              ),
              child: Text(labels[i],
                style: TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w600,
                  color: active ? c.primary : c.textSecondary,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTimelineList(List<AppointmentEntity> items) {
    final grouped = <String, List<AppointmentEntity>>{};
    for (final a in items) {
      final d = a.date ?? a.appointmentDate ?? '';
      DateTime? dt = DateTime.tryParse(d);
      final key = dt != null ? '${dt.year}-${dt.month.toString().padLeft(2, '0')}' : d;
      grouped.putIfAbsent(key, () => []);
      grouped[key]!.add(a);
    }

    final flat = <({bool isDivider, String monthLabel, AppointmentEntity? apt, bool isFirst, bool isLast})>[];
    for (final entry in grouped.entries) {
      final parts = entry.key.split('-');
      String monthLabel;
      if (parts.length == 2) {
        const months = ['', AppStrings.monthJan, AppStrings.monthFeb, AppStrings.monthMar,
          AppStrings.monthApr, AppStrings.monthMay, AppStrings.monthJun,
          AppStrings.monthJul, AppStrings.monthAug, AppStrings.monthSep,
          AppStrings.monthOct, AppStrings.monthNov, AppStrings.monthDec];
        monthLabel = '${months[int.parse(parts[1])]} ${parts[0]}';
      } else {
        monthLabel = entry.key;
      }
      flat.add((isDivider: true, monthLabel: monthLabel, apt: null, isFirst: false, isLast: false));
      final apts = entry.value;
      for (var i = 0; i < apts.length; i++) {
        flat.add((isDivider: false, monthLabel: '', apt: apts[i], isFirst: i == 0, isLast: i == apts.length - 1));
      }
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.sm, AppSpacing.md, 100),
      itemCount: flat.length,
      itemBuilder: (_, i) {
        final item = flat[i];
        if (item.isDivider) {
          return MonthDivider(monthLabel: item.monthLabel);
        }
        final apt = item.apt!;
        return AppointmentTimelineRow(
          appointment: apt,
          isFirst: item.isFirst,
          isLast: item.isLast,
          isFeatured: _showUpcoming && item.isFirst && apt.status == AppointmentStatus.confirmed,
          isPast: !_showUpcoming,
          onMoreTap: () => _showOptions(apt),
          onTap: () => _showOptions(apt),
        );
      },
    );
  }

  void _showOptions(AppointmentEntity apt) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => AppointmentOptionsSheet(appointment: apt),
    );
  }

  void _sortByDate(List<AppointmentEntity> items) {
    items.sort((a, b) {
      final ad = a.date ?? a.appointmentDate ?? '';
      final bd = b.date ?? b.appointmentDate ?? '';
      final aDt = DateTime.tryParse(ad);
      final bDt = DateTime.tryParse(bd);
      if (aDt == null && bDt == null) return 0;
      if (aDt == null) return 1;
      if (bDt == null) return -1;
      return _showUpcoming ? aDt.compareTo(bDt) : bDt.compareTo(aDt);
    });
  }
}
