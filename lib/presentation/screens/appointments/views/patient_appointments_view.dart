import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/domain/entities/appointment_entity.dart';
import 'package:clinic_management_app/presentation/blocs/appointment/appointment_bloc.dart';
import 'package:clinic_management_app/presentation/blocs/appointment/appointment_event.dart';
import 'package:clinic_management_app/presentation/blocs/appointment/appointment_state.dart';
import 'package:clinic_management_app/presentation/widgets/animated_card.dart';
import 'package:clinic_management_app/presentation/widgets/empty_data/empty_data_widget.dart';
import 'package:clinic_management_app/presentation/widgets/glass_card.dart';
import 'package:clinic_management_app/presentation/widgets/skeleton/skeleton.dart';

class PatientAppointmentsView extends StatefulWidget {
  const PatientAppointmentsView({super.key});

  @override
  State<PatientAppointmentsView> createState() => _PatientAppointmentsViewState();
}

class _PatientAppointmentsViewState extends State<PatientAppointmentsView> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final now = DateTime.now();

    return Column(
      children: [
        _buildHeader(colors),
        Expanded(
          child: BlocBuilder<AppointmentBloc, AppointmentState>(
            builder: (context, state) {
              if (state is AppointmentLoading && _tabController.index == 0) {
                return const SkeletonList();
              }
              if (state is AppointmentLoaded) {
                final upcoming = state.appointments.where((a) {
                  final d = a.date;
                  return d != null && (DateTime.tryParse(d) ?? now).isAfter(now.subtract(const Duration(days: 1)));
                }).toList();
                final past = state.appointments.where((a) {
                  final d = a.date;
                  return d != null && (DateTime.tryParse(d) ?? now).isBefore(now);
                }).toList();

                return Column(
                  children: [
                    _buildTabBar(colors),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _buildList(upcoming, colors, isUpcoming: true),
                          _buildList(past, colors, isUpcoming: false),
                        ],
                      ),
                    ),
                  ],
                );
              }
              if (state is AppointmentError) {
                return Center(child: Text(state.message, style: TextStyle(color: colors.error)));
              }
              return const EmptyDataWidget(icon: Icons.calendar_month_outlined, title: AppStrings.noData, compact: true);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(AppColorSet colors) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppStrings.appointments, style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: colors.textPrimary)),
          const SizedBox(height: 2),
          Text(AppStrings.ntCategoryAll, style: TextStyle(fontSize: 14, color: colors.textLight)),
        ],
      ),
    );
  }

  Widget _buildTabBar(AppColorSet colors) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: colors.cardBg.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: colors.primaryDark,
          borderRadius: BorderRadius.circular(10),
        ),
        indicatorColor: Colors.transparent,
        labelColor: Colors.white,
        unselectedLabelColor: colors.textSecondary,
        labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        tabs: const [
          Tab(text: 'القادمة'),
          Tab(text: 'السابقة'),
        ],
      ),
    );
  }

  Widget _buildList(List<AppointmentEntity> appointments, AppColorSet colors, {required bool isUpcoming}) {
    if (appointments.isEmpty) {
      return const EmptyDataWidget(icon: Icons.event_busy_rounded, title: AppStrings.noAppointments, compact: true);
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: appointments.length,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: AnimatedCard(
          index: index,
          child: _buildAppointmentCard(appointments[index], colors, isUpcoming),
        ),
      ),
    );
  }

  Widget _buildAppointmentCard(AppointmentEntity appt, AppColorSet colors, bool isUpcoming) {
    final statusValue = appt.status.toValue();
    final (statusColor, statusLabel) = _statusInfo(colors, statusValue);
    final imgUrl = appt.doctor?.imageUrl;
    final docName = appt.doctorName ?? '';
    final specialty = appt.doctor?.specialty ?? '';
    final rating = appt.doctor?.rating ?? 0.0;
    final ratingCount = appt.doctor?.reviewsCount ?? 0;

    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: colors.primary.withValues(alpha: 0.15),
                backgroundImage: imgUrl != null ? NetworkImage(imgUrl) : null,
                child: imgUrl == null
                    ? Icon(Icons.person_rounded, color: colors.primary, size: 28)
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(docName, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: colors.textPrimary)),
                    const SizedBox(height: 2),
                    Text(specialty, style: TextStyle(fontSize: 13, color: colors.primary)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.star_rounded, size: 16, color: colors.warning),
                        const SizedBox(width: 4),
                        Text(rating > 0 ? '$rating' : '', style: TextStyle(fontSize: 12, color: colors.textSecondary)),
                        if (ratingCount > 0) ...[
                          const SizedBox(width: 4),
                          Text('($ratingCount)', style: TextStyle(fontSize: 11, color: colors.textLight)),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              Icon(Icons.verified_rounded, color: colors.primary, size: 22),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: colors.divider.withValues(alpha: 0.1)), bottom: BorderSide(color: colors.divider.withValues(alpha: 0.1))),
            ),
            child: Row(
              children: [
                _buildInfoChip(colors, Icons.calendar_today_rounded, appt.date ?? ''),
                const SizedBox(width: 16),
                _buildInfoChip(colors, Icons.schedule_rounded, appt.timeSlot ?? ''),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildStatusBadge(colors, statusColor, statusLabel),
              const Spacer(),
              if (isUpcoming && statusValue != 'cancelled' && statusValue != 'completed') ...[
                _buildActionButton(colors, Icons.edit_calendar_rounded, 'إعادة جدولة', colors.primaryDark, () {}),
                const SizedBox(width: 8),
                _buildActionButton(colors, Icons.cancel_rounded, AppStrings.cancel, colors.error, () {
                  context.read<AppointmentBloc>().add(AppointmentUpdateStatus(appt.id, AppointmentStatus.cancelled));
                }),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(AppColorSet colors, IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: colors.primary),
        const SizedBox(width: 4),
        Text(text, style: TextStyle(fontSize: 12, color: colors.textSecondary)),
      ],
    );
  }

  Widget _buildStatusBadge(AppColorSet colors, Color color, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600)),
    );
  }

  Widget _buildActionButton(AppColorSet colors, IconData icon, String label, Color color, VoidCallback onPressed) {
    return SizedBox(
      height: 36,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 16),
        label: Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        style: OutlinedButton.styleFrom(
          foregroundColor: color,
          side: BorderSide(color: color.withValues(alpha: 0.3)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 10),
        ),
      ),
    );
  }

  (Color, String) _statusInfo(AppColorSet colors, String status) {
    return switch (status) {
      'set' || 'accepted' => (colors.primary, AppStrings.scheduled),
      'completed' => (colors.success, AppStrings.completed),
      'cancelled' => (colors.error, AppStrings.cancelled),
      'in_progress' => (colors.accent, AppStrings.inProgress),
      'requested' => (colors.warning, 'قيد المراجعة'),
      _ => (colors.textLight, status),
    };
  }
}
