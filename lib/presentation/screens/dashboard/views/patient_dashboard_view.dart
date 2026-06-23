import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_routes.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';
import 'package:clinic_management_app/presentation/blocs/dashboard/dashboard_bloc.dart';
import 'package:clinic_management_app/presentation/blocs/dashboard/dashboard_state.dart';
import 'package:clinic_management_app/presentation/widgets/dashboard/action_button.dart';
import 'package:clinic_management_app/presentation/widgets/dashboard/dashboard_greeting.dart';
import 'package:clinic_management_app/presentation/widgets/dashboard/glass_stat_card.dart';
import 'package:clinic_management_app/presentation/widgets/dashboard/recent_appointments.dart';
import 'package:clinic_management_app/presentation/widgets/animated_card.dart';
import 'package:clinic_management_app/presentation/widgets/skeleton/dashboard_skeleton.dart';

class PatientDashboardView extends StatelessWidget {
  const PatientDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return SingleChildScrollView(
      child: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          if (state is DashboardLoading || state is DashboardInitial) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedCard(index: 0, child: const DashboardGreeting()),
                const SizedBox(height: AppSpacing.lg),
                const DashboardSkeleton(),
              ],
            );
          }
          if (state is DashboardError) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedCard(index: 0, child: const DashboardGreeting()),
                const SizedBox(height: AppSpacing.lg),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
                  child: Center(
                    child: Text(
                      state.message,
                      style: TextStyle(color: colors.error, fontSize: AppSpacing.bodyMedium),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            );
          }
          if (state is DashboardLoaded) {
            final d = state.data;
            final a = d.appointments;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedCard(index: 0, child: const DashboardGreeting()),
                const SizedBox(height: AppSpacing.lg),
                _sectionTitle(colors, AppStrings.appointments),
                const SizedBox(height: AppSpacing.sm + AppSpacing.xs),
                _buildAppointmentsGrid(colors, a.total, a.upcoming,
                    a.byStatus['completed'], a.byStatus['cancelled']),
                const SizedBox(height: AppSpacing.lg),
                _sectionTitle(colors, AppStrings.myFile),
                const SizedBox(height: AppSpacing.sm + AppSpacing.xs),
                _buildMedicalGrid(colors,
                    d.doctors?.total, d.totalMedicalRecords, d.totalPrescriptions),
                const SizedBox(height: AppSpacing.lg),
                AnimatedCard(
                  index: 6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppStrings.quickActions, style: TextStyle(fontSize: AppSpacing.titleMedium, fontWeight: FontWeight.w600, color: colors.textPrimary)),
                      const SizedBox(height: AppSpacing.sm + AppSpacing.xs),
                      Row(children: [
                        Expanded(child: ActionButton(icon: Icons.calendar_month, label: AppStrings.myAppointments, color: colors.primary, onPressed: () => Navigator.pushNamed(context, AppRoutes.appointments))),
                        const SizedBox(width: AppSpacing.sm + AppSpacing.xs),
                        Expanded(child: ActionButton(icon: Icons.folder, label: AppStrings.myRecords, color: colors.secondary, onPressed: () => Navigator.pushNamed(context, AppRoutes.medicalRecords))),
                      ]),
                      const SizedBox(height: AppSpacing.sm + AppSpacing.xs),
                      Row(children: [
                        Expanded(child: ActionButton(icon: Icons.person, label: AppStrings.myFile, color: colors.accent, onPressed: () => Navigator.pushNamed(context, AppRoutes.profile))),
                        const SizedBox(width: AppSpacing.sm + AppSpacing.xs),
                        Expanded(child: ActionButton(icon: Icons.settings, label: AppStrings.settings, color: colors.primaryDark, onPressed: () => Navigator.pushNamed(context, AppRoutes.settings))),
                      ]),
                      const SizedBox(height: AppSpacing.sm + AppSpacing.xs),
                      Row(children: [
                        Expanded(child: ActionButton(icon: Icons.supervisor_account, label: AppStrings.supervisionRequests, color: colors.success, onPressed: () => Navigator.pushNamed(context, AppRoutes.supervisionRequests))),
                        const SizedBox(width: AppSpacing.sm + AppSpacing.xs),
                        Expanded(child: ActionButton(icon: Icons.file_download, label: AppStrings.dfTitle, color: colors.secondary, onPressed: () => Navigator.pushNamed(context, AppRoutes.downloadFiles))),
                      ]),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                AnimatedCard(
                  index: 7,
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
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _sectionTitle(AppColorSet colors, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Text(
        title,
        style: TextStyle(
          fontSize: AppSpacing.titleMedium,
          fontWeight: FontWeight.w700,
          color: colors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildAppointmentsGrid(AppColorSet colors, int? total, int? upcoming, int? completed, int? cancelled) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.4,
        children: [
          GlassStatCard(index: 0, title: AppStrings.totalAppts, icon: Icons.event, color: colors.primary, value: total?.toString()),
          GlassStatCard(index: 1, title: AppStrings.upcomingAppts, icon: Icons.schedule, color: colors.warning, value: upcoming?.toString()),
          GlassStatCard(index: 2, title: AppStrings.completedAppts, icon: Icons.check_circle, color: colors.success, value: completed?.toString()),
          GlassStatCard(index: 3, title: AppStrings.cancelledAppts, icon: Icons.cancel, color: colors.error, value: cancelled?.toString()),
        ],
      ),
    );
  }

  Widget _buildMedicalGrid(AppColorSet colors, int? doctors, int? records, int? prescriptions) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.0,
        children: [
          GlassStatCard(index: 4, title: AppStrings.totalDoctors, icon: Icons.medical_services, color: colors.primary, value: doctors?.toString()),
          GlassStatCard(index: 5, title: AppStrings.medicalRecords, icon: Icons.folder, color: colors.accent, value: records?.toString()),
          GlassStatCard(index: 6, title: AppStrings.totalPrescriptions, icon: Icons.description, color: colors.secondary, value: prescriptions?.toString()),
        ],
      ),
    );
  }
}

