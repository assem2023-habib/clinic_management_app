import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';
import 'package:clinic_management_app/core/constants/app_routes.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
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

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.rhScheduleOverview,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: colors.textLight),
              ),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, AppRoutes.appointments),
                child: Text(
                  AppStrings.rhViewFull,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: colors.secondary),
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
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: colors.textLight),
          ),
          const SizedBox(height: AppSpacing.sm),
          BlocBuilder<AppointmentBloc, AppointmentState>(
            builder: (context, state) {
              final appts = state is AppointmentLoaded ? state.appointments : <AppointmentEntity>[];
              final today = DateTime.now();
              final todayAppts = appts.where((a) =>
                a.date.year == today.year && a.date.month == today.month && a.date.day == today.day
              ).toList();
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
