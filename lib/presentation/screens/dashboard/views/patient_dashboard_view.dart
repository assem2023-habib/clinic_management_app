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

class PatientDashboardView extends StatelessWidget {
  const PatientDashboardView({super.key});

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
                    _buildAppointmentsGrid(colors,
                      d.appointments.upcoming ?? d.appointments.byStatus['confirmed'],
                      d.appointments.byStatus['pending'],
                      d.appointments.byStatus['completed'],
                      d.appointments.byStatus['cancelled'] ?? d.appointments.byStatus['cancelled'],
                    ),
                    const SizedBox(height: 16),
                    _buildClinicGrid(colors,
                      d.doctors?.total,
                      d.totalPrescriptions,
                      d.ratings?.average,
                    ),
                  ],
                );
              }
              return _buildAppointmentsGrid(colors, null, null, null, null);
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
                  Expanded(child: ActionButton(icon: Icons.folder, label: AppStrings.myRecords, color: colors.secondary, onPressed: () => Navigator.pushNamed(context, AppRoutes.medicalRecords))),
                ]),
                const SizedBox(height: 12),
                Row(children: [
                  Expanded(child: ActionButton(icon: Icons.person, label: AppStrings.myFile, color: colors.accent, onPressed: () => Navigator.pushNamed(context, AppRoutes.profile))),
                  const SizedBox(width: 12),
                  Expanded(child: ActionButton(icon: Icons.settings, label: AppStrings.settings, color: colors.primaryDark, onPressed: () => Navigator.pushNamed(context, AppRoutes.settings))),
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

  Widget _buildAppointmentsGrid(AppColorSet colors, int? upcoming, int? pending, int? completed, int? cancelled) {
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
              StatCard(title: AppStrings.upcomingAppts, icon: Icons.event, color: colors.primary, value: upcoming?.toString()),
              StatCard(title: AppStrings.pendingAppts, icon: Icons.pending_actions, color: colors.warning, value: pending?.toString()),
              StatCard(title: AppStrings.completedAppts, icon: Icons.check_circle, color: colors.success, value: completed?.toString()),
              StatCard(title: AppStrings.cancelledAppts, icon: Icons.cancel, color: colors.error, value: cancelled?.toString()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildClinicGrid(AppColorSet colors, int? doctors, int? prescriptions, double? avgRating) {
    return AnimatedCard(
      index: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text('العيادة', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: colors.textPrimary)),
          ),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.5,
            children: [
              StatCard(title: AppStrings.totalDoctors, icon: Icons.medical_services, color: colors.primary, value: doctors?.toString()),
              StatCard(title: AppStrings.totalPrescriptions, icon: Icons.description, color: colors.secondary, value: prescriptions?.toString()),
              StatCard(title: AppStrings.averageRating, icon: Icons.star, color: colors.warning, value: avgRating?.toStringAsFixed(1)),
              StatCard(title: AppStrings.medicalRecords, icon: Icons.folder, color: colors.accent, value: null),
            ],
          ),
        ],
      ),
    );
  }
}
