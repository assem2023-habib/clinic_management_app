import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_routes.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/domain/entities/appointment_entity.dart';
import 'package:clinic_management_app/presentation/blocs/appointment/appointment_bloc.dart';
import 'package:clinic_management_app/presentation/blocs/appointment/appointment_event.dart';
import 'package:clinic_management_app/presentation/blocs/appointment/appointment_state.dart';
import 'package:clinic_management_app/presentation/blocs/auth/auth_cubit.dart';
import 'package:clinic_management_app/presentation/blocs/doctor/doctor_bloc.dart';
import 'package:clinic_management_app/presentation/blocs/doctor/doctor_state.dart';
import 'package:clinic_management_app/presentation/screens/doctor_appointments/widgets/dr_stats_cards.dart';
import 'package:clinic_management_app/presentation/screens/doctor_appointments/widgets/dr_quick_actions.dart';
import 'package:clinic_management_app/presentation/screens/doctor_appointments/widgets/dr_queue_item.dart';
import 'package:clinic_management_app/presentation/widgets/empty_data/empty_data_widget.dart';
import 'package:clinic_management_app/presentation/widgets/glass_card.dart';

class DrLiveQueue extends StatefulWidget {
  const DrLiveQueue({super.key});

  @override
  State<DrLiveQueue> createState() => _DrLiveQueueState();
}

class _DrLiveQueueState extends State<DrLiveQueue> {
  String? _userId;
  late final AppointmentBloc _appointmentBloc;

  @override
  void initState() {
    super.initState();
    _appointmentBloc = context.read<AppointmentBloc>();
    final userId = context.read<AuthCubit>().state.userId;
    if (userId != null) {
      _userId = userId;
      _appointmentBloc.add(AppointmentWatchRtdb(userId));
    }
  }

  @override
  void dispose() {
    final userId = _userId;
    if (userId != null) {
      _appointmentBloc.add(AppointmentStopRtdb(userId));
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final userName = context.watch<AuthCubit>().state.userName ?? '';

    return BlocBuilder<AppointmentBloc, AppointmentState>(
      builder: (context, state) {
        final appointments = state is AppointmentLoaded ? state.appointments : <AppointmentEntity>[];
        final today = DateTime.now();
        final todayAppts = appointments.where((a) {
          final d = a.date;
          return d != null && DateTime.tryParse(d)?.year == today.year && DateTime.tryParse(d)?.month == today.month && DateTime.tryParse(d)?.day == today.day;
        }).toList();

        final totalToday = todayAppts.length;
        final waiting = todayAppts.where((a) => a.status == AppointmentStatus.scheduled).length;
        final emergencyCount = 0;

        final queueOrder = [AppointmentStatus.inProgress, AppointmentStatus.scheduled, AppointmentStatus.cancelled];
        todayAppts.sort((a, b) {
          final aIdx = queueOrder.indexOf(a.status);
          final bIdx = queueOrder.indexOf(b.status);
          if (aIdx != bIdx) return aIdx.compareTo(bIdx);
          return (a.timeSlot ?? '').compareTo(b.timeSlot ?? '');
        });

        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppSpacing.md),
                    _buildGreeting(colors, userName, waiting),
                    const SizedBox(height: AppSpacing.md),
                    DrStatsCards(
                      totalToday: totalToday,
                      waitingPatients: waiting,
                      emergencyCount: emergencyCount,
                      availableDoctors: _availableDoctorCount(context),
                      totalDoctors: _totalDoctorCount(context),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    DrQuickActions(
                      onRegisterPatient: () {},
                      onAddAppointment: () => Navigator.pushNamed(context, AppRoutes.userBooking),
                      onManageSchedule: () {},
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(AppStrings.daLiveQueue,
                          style: TextStyle(fontSize: AppSpacing.titleMedium, fontWeight: FontWeight.w600, color: colors.textPrimary)),
                        TextButton(
                          onPressed: () {},
                          child: Text(AppStrings.daViewAll, style: TextStyle(color: colors.primary, fontSize: 13)),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                  ],
                ),
              ),
            ),
            if (todayAppts.isEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  child:  EmptyDataWidget(icon: Icons.event_busy_rounded, title: AppStrings.daNoApptsToday, compact: true),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final appt = todayAppts[index];
                      final isLast = index == todayAppts.length - 1;
                      return Column(
                        children: [
                          DrQueueItem(
                            queueNumber: index + 1,
                            patientName: appt.patientName ?? '',
                            doctorName: '${AppStrings.daWithDoctor} ${appt.doctorName ?? ''}',
                            checkInTime: appt.timeSlot ?? '',
                            isEmergency: false,
                          ),
                          if (!isLast)
                            Divider(height: 1, color: colors.divider.withValues(alpha: 0.05)),
                        ],
                      );
                    },
                    childCount: todayAppts.length,
                  ),
                ),
              ),
            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.sm)),
          ],
        );
      },
    );
  }

  Widget _buildGreeting(AppColorSet colors, String userName, int waitingCount) {
    final hour = DateTime.now().hour;
    final greeting = hour < 12 ? 'صباح الخير' : hour < 18 ? 'مساء الخير' : 'مساء الخير';
    return GlassCard(
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: colors.primary.withValues(alpha: 0.15),
            child: Icon(Icons.person_rounded, color: colors.primary, size: 28),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$greeting، $userName', style: TextStyle(fontSize: AppSpacing.bodyLarge, fontWeight: FontWeight.bold, color: colors.textPrimary)),
                Text('لديك $waitingCount مرضى ينتظرون', style: TextStyle(fontSize: 13, color: colors.textLight)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  int _availableDoctorCount(BuildContext context) {
    final state = context.read<DoctorBloc>().state;
    if (state is DoctorLoaded) {
      return state.doctors.where((d) => d.isAvailable).length;
    }
    return 0;
  }

  int _totalDoctorCount(BuildContext context) {
    final state = context.read<DoctorBloc>().state;
    if (state is DoctorLoaded) {
      return state.doctors.length;
    }
    return 0;
  }
}
