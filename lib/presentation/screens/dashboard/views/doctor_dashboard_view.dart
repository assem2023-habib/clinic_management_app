import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_routes.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/presentation/blocs/dashboard/dashboard_bloc.dart';
import 'package:clinic_management_app/presentation/blocs/dashboard/dashboard_state.dart';
import 'package:clinic_management_app/presentation/widgets/dashboard/action_button.dart';
import 'package:clinic_management_app/presentation/widgets/dashboard/dashboard_greeting.dart';
import 'package:clinic_management_app/presentation/widgets/dashboard/recent_appointments.dart';
import 'package:clinic_management_app/presentation/widgets/dashboard/stat_card.dart';
import 'package:clinic_management_app/presentation/widgets/animated_card.dart';

class DoctorDashboardView extends StatelessWidget {
  const DoctorDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedCard(index: 0, child: const DashboardGreeting()),
          const SizedBox(height: 24),
          BlocBuilder<DashboardBloc, DashboardState>(
            builder: (context, state) {
              if (state is DashboardLoaded) {
                final d = state.data;
                return Column(
                  children: [
                    _buildPatientsGrid(colors,
                      d.patients?.total,
                      d.patients?.newThisMonth,
                      d.patients?.registeredToday,
                    ),
                    const SizedBox(height: 16),
                    _buildAppointmentsGrid(colors,
                      d.appointments.today,
                      d.appointments.thisWeek,
                      d.appointments.thisMonth,
                      d.appointments.byStatus['pending'],
                      d.appointments.byStatus['confirmed'],
                      d.appointments.byStatus['completed'],
                    ),
                    const SizedBox(height: 16),
                    _buildRecordsGrid(colors,
                      d.totalMedicalRecords,
                      d.totalPrescriptions,
                    ),
                  ],
                );
              }
              return _buildPatientsGrid(colors, null, null, null);
            },
          ),
          const SizedBox(height: 24),
          AnimatedCard(
            index: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppStrings.quickActions, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: colors.textPrimary)),
                const SizedBox(height: 12),
                Row(children: [
                  Expanded(child: ActionButton(icon: Icons.calendar_month, label: AppStrings.myAppointments, color: colors.primary, onPressed: () => Navigator.pushNamed(context, AppRoutes.appointments))),
                  const SizedBox(width: 12),
                  Expanded(child: ActionButton(icon: Icons.people, label: AppStrings.myPatients, color: colors.secondary, onPressed: () => Navigator.pushNamed(context, AppRoutes.patients))),
                ]),
                const SizedBox(height: 12),
                Row(children: [
                  Expanded(child: ActionButton(icon: Icons.folder, label: AppStrings.medicalRecords, color: colors.accent, onPressed: () => Navigator.pushNamed(context, AppRoutes.medicalRecords))),
                  const SizedBox(width: 12),
                  Expanded(child: ActionButton(icon: Icons.description, label: AppStrings.medicalReport, color: colors.primaryDark, onPressed: () {})),
                ]),
              ],
            ),
          ),
          const SizedBox(height: 24),
          AnimatedCard(
            index: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppStrings.latestAppointments, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: colors.textPrimary)),
                const SizedBox(height: 12),
                const RecentAppointments(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientsGrid(AppColorSet colors, int? total, int? newThisMonth, int? registeredToday) {
    return AnimatedCard(
      index: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(AppStrings.myPatientsV2, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: colors.textPrimary)),
          ),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.5,
            children: [
              StatCard(title: AppStrings.totalPatients, icon: Icons.people, color: colors.primary, value: total?.toString()),
              StatCard(title: AppStrings.newThisMonth, icon: Icons.fiber_new, color: colors.accent, value: newThisMonth?.toString()),
              StatCard(title: AppStrings.registeredToday, icon: Icons.today, color: colors.warning, value: registeredToday?.toString()),
              StatCard(title: AppStrings.newPatients, icon: Icons.person_add, color: colors.secondary, value: newThisMonth != null ? '${newThisMonth}' : null),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentsGrid(AppColorSet colors, int? today, int? thisWeek, int? thisMonth, int? pending, int? confirmed, int? completed) {
    return AnimatedCard(
      index: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(AppStrings.appointments, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: colors.textPrimary)),
          ),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.5,
            children: [
              StatCard(title: AppStrings.todayAppts, icon: Icons.today, color: colors.secondary, value: today?.toString()),
              StatCard(title: AppStrings.thisWeekAppts, icon: Icons.date_range, color: colors.primary, value: thisWeek?.toString()),
              StatCard(title: AppStrings.thisMonthAppts, icon: Icons.calendar_month, color: colors.warning, value: thisMonth?.toString()),
              StatCard(title: AppStrings.pendingAppts, icon: Icons.pending_actions, color: colors.accent, value: pending?.toString()),
              StatCard(title: AppStrings.confirmedAppts, icon: Icons.verified, color: colors.success, value: confirmed?.toString()),
              StatCard(title: AppStrings.completedAppts, icon: Icons.check_circle, color: colors.primary, value: completed?.toString()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecordsGrid(AppColorSet colors, int? medicalRecords, int? prescriptions) {
    return AnimatedCard(
      index: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(AppStrings.medicalRecords, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: colors.textPrimary)),
          ),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.5,
            children: [
              StatCard(title: AppStrings.medicalRecords, icon: Icons.folder, color: colors.primary, value: medicalRecords?.toString()),
              StatCard(title: AppStrings.totalPrescriptions, icon: Icons.description, color: colors.secondary, value: prescriptions?.toString()),
            ],
          ),
        ],
      ),
    );
  }
}
