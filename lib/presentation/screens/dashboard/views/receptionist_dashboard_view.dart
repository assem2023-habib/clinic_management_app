import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';
import 'package:clinic_management_app/core/constants/app_routes.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/presentation/blocs/dashboard/dashboard_bloc.dart';
import 'package:clinic_management_app/presentation/blocs/dashboard/dashboard_state.dart';
import 'package:clinic_management_app/presentation/blocs/appointment/appointment_bloc.dart';
import 'package:clinic_management_app/presentation/blocs/appointment/appointment_event.dart';
import 'package:clinic_management_app/presentation/blocs/appointment/appointment_state.dart';
import 'package:clinic_management_app/domain/entities/appointment_entity.dart';
import 'package:clinic_management_app/presentation/screens/receptionist_home/widgets/rh_greeting_section.dart';
import 'package:clinic_management_app/presentation/screens/receptionist_home/widgets/rh_calendar_bar.dart';
import 'package:clinic_management_app/presentation/screens/receptionist_home/widgets/rh_clinic_pulse.dart';
import 'package:clinic_management_app/presentation/screens/receptionist_home/widgets/rh_quick_actions.dart';
import 'package:clinic_management_app/presentation/screens/receptionist_home/widgets/rh_active_queue.dart';
import 'package:clinic_management_app/presentation/widgets/appointment_form_dialog.dart';
import 'package:clinic_management_app/presentation/widgets/dashboard/stat_card.dart';
import 'package:clinic_management_app/presentation/widgets/animated_card.dart';
import 'package:clinic_management_app/core/constants/app_icons.dart';

class ReceptionistDashboardView extends StatefulWidget {
  const ReceptionistDashboardView({super.key});

  @override
  State<ReceptionistDashboardView> createState() => _ReceptionistDashboardViewState();
}

class _ReceptionistDashboardViewState extends State<ReceptionistDashboardView> {
  DateTime _selectedDate = DateTime.now();
  late List<DateTime> _dates;

  @override
  void initState() {
    super.initState();
    _dates = List.generate(7, (i) => DateTime.now().add(Duration(days: i)));
    context.read<AppointmentBloc>().add(AppointmentLoadAll());
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const RhGreetingSection(),
          const SizedBox(height: AppSpacing.lg),

          BlocBuilder<DashboardBloc, DashboardState>(
            builder: (context, state) {
              if (state is DashboardLoaded) {
                final d = state.data;
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                  child: AnimatedCard(
                    index: 0,
                    child: GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.5,
                      children: [
                        StatCard(title: AppStrings.todayAppointments, icon: AppIcons.today, color: colors.primary, value: d.appointments.today?.toString()),
                        StatCard(title: AppStrings.totalPatients, icon: AppIcons.people, color: colors.secondary, value: d.patients?.total.toString()),
                        StatCard(title: AppStrings.totalDoctors, icon: AppIcons.medicalServices, color: colors.accent, value: d.doctors?.total.toString()),
                        StatCard(title: AppStrings.registeredToday, icon: AppIcons.personAdd, color: colors.warning, value: d.patients?.registeredToday?.toString()),
                      ],
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.rhScheduleOverview,
                style: TextStyle(fontSize: AppSpacing.bodySmall, fontWeight: FontWeight.w600, color: colors.textLight),
              ),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, AppRoutes.appointments),
                child: Text(
                  AppStrings.rhViewFull,
                  style: TextStyle(fontSize: AppSpacing.bodySmall, fontWeight: FontWeight.w500, color: colors.secondary),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          RhCalendarBar(
            dates: _dates,
            selectedDate: _selectedDate,
            onSelectDate: (date) {
              setState(() => _selectedDate = date);
              context.read<AppointmentBloc>().add(AppointmentLoadByDate(date));
            },
          ),
          const SizedBox(height: AppSpacing.lg),

          Text(
            AppStrings.rhClinicPulse,
            style: TextStyle(fontSize: AppSpacing.bodySmall, fontWeight: FontWeight.w600, color: colors.textLight),
          ),
          const SizedBox(height: AppSpacing.sm),
          BlocBuilder<AppointmentBloc, AppointmentState>(
            builder: (context, state) {
              final appts = state is AppointmentLoaded ? state.appointments : <AppointmentEntity>[];
              final today = DateTime.now();
              final todayAppts = appts.where((a) {
                final d = a.date;
                return d != null && DateTime.tryParse(d)?.year == today.year && DateTime.tryParse(d)?.month == today.month && DateTime.tryParse(d)?.day == today.day;
              }).toList();
              return RhClinicPulse(
                totalAppts: todayAppts.length,
                checkedIn: todayAppts.where((a) => a.status == AppointmentStatus.scheduled).length,
                inProgress: todayAppts.where((a) => a.status == AppointmentStatus.inProgress).length,
                pending: todayAppts.where((a) => a.status == AppointmentStatus.cancelled).length,
              );
            },
          ),
          const SizedBox(height: AppSpacing.lg),

          RhQuickActions(
            onNewAppointment: () {
              showDialog(context: context, builder: (_) => const AppointmentFormDialog());
            },
            onRegisterPatient: () => Navigator.pushNamed(context, AppRoutes.patients),
            onScanMedicalId: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(AppStrings.rhScannerActivating)),
              );
            },
          ),
          const SizedBox(height: AppSpacing.lg),

          const RhActiveQueue(),
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }
}
