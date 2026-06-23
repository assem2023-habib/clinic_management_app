import 'package:clinic_management_app/core/constants/app_icons.dart';
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
import 'package:clinic_management_app/core/constants/app_spacing.dart';

class AdminDashboardView extends StatelessWidget {
  const AdminDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedCard(index: 0, child: const DashboardGreeting()),
          const SizedBox(height: AppSpacing.lg),
          BlocBuilder<DashboardBloc, DashboardState>(
            builder: (context, state) {
              if (state is DashboardLoading) {
                return const SizedBox(height: 200, child: Center(child: CircularProgressIndicator()));
              }
              if (state is DashboardLoaded) {
                final d = state.data;
                return Column(
                  children: [
                    _buildUsersStatGrid(colors,
                      d.users?.total,
                      d.users?.active,
                      d.users?.inactive,
                      d.users?.newToday,
                      d.users?.newThisWeek,
                      d.users?.newThisMonth,
                      d.users?.doctors,
                      d.users?.patients,
                      d.users?.receptionists,
                      d.users?.admins,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _buildAppointmentsStatGrid(colors,
                      d.appointments.total,
                      d.appointments.today,
                      d.appointments.thisWeek,
                      d.appointments.thisMonth,
                      d.appointments.byStatus['pending'],
                      d.appointments.byStatus['confirmed'],
                      d.appointments.byStatus['completed'],
                      d.appointments.byStatus['cancelled'],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _buildOtherStatGrid(colors,
                      d.totalMedicalRecords,
                      d.totalPrescriptions,
                      d.specializations?.total,
                      d.ratings?.average,
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
          const SizedBox(height: AppSpacing.lg),
          AnimatedCard(
            index: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppStrings.quickActions, style: TextStyle(fontSize: AppSpacing.titleMedium, fontWeight: FontWeight.w600, color: colors.textPrimary)),
                const SizedBox(height: AppSpacing.sm + AppSpacing.xs),
                Row(children: [
                  Expanded(child: ActionButton(icon: AppIcons.personAdd, label: AppStrings.addDoctor, color: colors.primary, onPressed: () => Navigator.pushNamed(context, AppRoutes.doctors))),
                  const SizedBox(width: AppSpacing.sm + AppSpacing.xs),
                  Expanded(child: ActionButton(icon: AppIcons.people, label: AppStrings.patients, color: colors.secondary, onPressed: () => Navigator.pushNamed(context, AppRoutes.patients))),
                ]),
                const SizedBox(height: AppSpacing.sm + AppSpacing.xs),
                Row(children: [
                  Expanded(child: ActionButton(icon: AppIcons.calendarToday, label: AppStrings.addAppointment, color: colors.accent, onPressed: () => Navigator.pushNamed(context, AppRoutes.appointments))),
                  const SizedBox(width: AppSpacing.sm + AppSpacing.xs),
                  Expanded(child: ActionButton(icon: AppIcons.description, label: AppStrings.viewRecords, color: colors.primaryDark, onPressed: () => Navigator.pushNamed(context, AppRoutes.medicalRecords))),
                ]),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          AnimatedCard(
            index: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppStrings.latestAppointments, style: TextStyle(fontSize: AppSpacing.titleMedium, fontWeight: FontWeight.w600, color: colors.textPrimary)),
                const SizedBox(height: AppSpacing.sm + AppSpacing.xs),
                const RecentAppointments(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUsersStatGrid(AppColorSet colors, int? total, int? active, int? inactive, int? newToday, int? newThisWeek, int? newThisMonth, int? doctors, int? patients, int? receptionists, int? admins) {
    return AnimatedCard(
      index: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm + AppSpacing.xs),
            child: Text('المستخدمون', style: TextStyle(fontSize: AppSpacing.bodyLarge, fontWeight: FontWeight.w600, color: colors.textPrimary)),
          ),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.5,
            children: [
              StatCard(title: AppStrings.roleUser, icon: AppIcons.people, color: colors.primary, value: total?.toString()),
              StatCard(title: AppStrings.totalDoctors, icon: AppIcons.medicalServices, color: colors.primary, value: doctors?.toString()),
              StatCard(title: AppStrings.totalPatients, icon: AppIcons.people, color: colors.secondary, value: patients?.toString()),
              StatCard(title: AppStrings.activeUsers, icon: AppIcons.checkCircle, color: colors.success, value: active?.toString()),
              StatCard(title: AppStrings.inactiveUsers, icon: AppIcons.cancel, color: colors.error, value: inactive?.toString()),
              StatCard(title: AppStrings.newToday, icon: AppIcons.fiberNew, color: colors.accent, value: newToday?.toString()),
              StatCard(title: AppStrings.newThisWeek, icon: AppIcons.dateRange, color: colors.warning, value: newThisWeek?.toString()),
              StatCard(title: AppStrings.newThisMonth, icon: AppIcons.calendarMonth, color: colors.primary, value: newThisMonth?.toString()),
              StatCard(title: AppStrings.roleReceptionist, icon: AppIcons.personPin, color: colors.primaryDark, value: receptionists?.toString()),
              StatCard(title: AppStrings.roleAdmin, icon: AppIcons.adminPanelSettings, color: colors.secondary, value: admins?.toString()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentsStatGrid(AppColorSet colors, int? total, int? today, int? thisWeek, int? thisMonth, int? pending, int? confirmed, int? completed, int? cancelled) {
    return AnimatedCard(
      index: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm + AppSpacing.xs),
            child: Text(AppStrings.appointments, style: TextStyle(fontSize: AppSpacing.bodyLarge, fontWeight: FontWeight.w600, color: colors.textPrimary)),
          ),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.5,
            children: [
              StatCard(title: AppStrings.totalAppts, icon: AppIcons.eventNote, color: colors.primary, value: total?.toString()),
              StatCard(title: AppStrings.todayAppointments, icon: AppIcons.today, color: colors.accent, value: today?.toString()),
              StatCard(title: AppStrings.thisWeekAppts, icon: AppIcons.dateRange, color: colors.secondary, value: thisWeek?.toString()),
              StatCard(title: AppStrings.thisMonthAppts, icon: AppIcons.calendarMonth, color: colors.warning, value: thisMonth?.toString()),
              StatCard(title: AppStrings.pendingAppointments, icon: AppIcons.pending, color: colors.error, value: pending?.toString()),
              StatCard(title: AppStrings.confirmedAppts, icon: AppIcons.verified, color: colors.success, value: confirmed?.toString()),
              StatCard(title: AppStrings.completedAppts, icon: AppIcons.checkCircle, color: colors.primary, value: completed?.toString()),
              StatCard(title: AppStrings.cancelledAppts, icon: AppIcons.cancel, color: colors.textLight, value: cancelled?.toString()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOtherStatGrid(AppColorSet colors, int? medicalRecords, int? prescriptions, int? specializations, double? avgRating) {
    return AnimatedCard(
      index: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm + AppSpacing.xs),
            child: Text('العيادة', style: TextStyle(fontSize: AppSpacing.bodyLarge, fontWeight: FontWeight.w600, color: colors.textPrimary)),
          ),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.5,
            children: [
              StatCard(title: AppStrings.medicalRecords, icon: AppIcons.folder, color: colors.primary, value: medicalRecords?.toString()),
              StatCard(title: AppStrings.totalPrescriptions, icon: AppIcons.description, color: colors.secondary, value: prescriptions?.toString()),
              StatCard(title: AppStrings.totalSpecializations, icon: AppIcons.category, color: colors.accent, value: specializations?.toString()),
              StatCard(title: AppStrings.averageRating, icon: AppIcons.star, color: colors.warning, value: avgRating?.toStringAsFixed(1)),
            ],
          ),
        ],
      ),
    );
  }
}

