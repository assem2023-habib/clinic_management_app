import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/core/constants/app_routes.dart';
import 'package:clinic_management_app/presentation/blocs/auth/auth_cubit.dart';
import 'package:clinic_management_app/presentation/blocs/onboarding/onboarding_state.dart';
import 'package:clinic_management_app/presentation/blocs/appointment/appointment_bloc.dart';
import 'package:clinic_management_app/presentation/blocs/appointment/appointment_state.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.dashboard),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthCubit>().logout();
              Navigator.pushReplacementNamed(context, AppRoutes.login);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocBuilder<AuthCubit, AuthState>(
              builder: (context, authState) {
                String roleLabel;
                switch (authState.role) {
                  case UserRole.admin: roleLabel = 'مُدِير العِيَادَة'; break;
                  case UserRole.doctor: roleLabel = 'طَبِيب'; break;
                  case UserRole.receptionist: roleLabel = 'مَسْؤُول الاسْتِقْبَال'; break;
                  case UserRole.patient: roleLabel = 'مَرِيض'; break;
                  default: roleLabel = 'مُدِير العِيَادَة';
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'مَرْحَباً، ${authState.userName ?? ''}',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: colors.textPrimary),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      roleLabel,
                      style: TextStyle(fontSize: 14, color: colors.primary, fontWeight: FontWeight.w600),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),
            _buildStats(context),
            const SizedBox(height: 24),
            _buildQuickActions(context),
            const SizedBox(height: 24),
            Text(
              'Recent Appointments',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: colors.textPrimary),
            ),
            const SizedBox(height: 12),
            _buildRecentAppointments(context),
          ],
        ),
      ),
    );
  }

  Widget _buildStats(BuildContext context) {
    final colors = AppColors.of(context);

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: [
        _buildStatCard(context, title: AppStrings.totalDoctors, icon: Icons.medical_services, color: colors.primary),
        _buildStatCard(context, title: AppStrings.totalPatients, icon: Icons.people, color: colors.secondary),
        _buildStatCard(context, title: AppStrings.todayAppointments, icon: Icons.today, color: colors.accent),
        _buildStatCard(context, title: AppStrings.pendingAppointments, icon: Icons.pending_actions, color: colors.error),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
  }) {
    final colors = AppColors.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: colors.textPrimary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final colors = AppColors.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: colors.textPrimary),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildActionButton(context, icon: Icons.person_add, label: AppStrings.addDoctor, color: colors.primary, route: AppRoutes.doctors),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionButton(context, icon: Icons.person_add_alt_1, label: AppStrings.addPatient, color: colors.secondary, route: AppRoutes.patients),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildActionButton(context, icon: Icons.calendar_today, label: AppStrings.addAppointment, color: colors.accent, route: AppRoutes.appointments),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionButton(context, icon: Icons.description, label: 'View Records', color: colors.primaryDark, route: AppRoutes.medicalRecords),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required String route,
  }) {
    return ElevatedButton(
      onPressed: () => Navigator.pushNamed(context, route),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20, color: Colors.white),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontSize: 14, color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildRecentAppointments(BuildContext context) {
    final colors = AppColors.of(context);

    return BlocBuilder<AppointmentBloc, AppointmentState>(
      builder: (context, state) {
        if (state is AppointmentLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is AppointmentLoaded) {
          final recent = state.appointments.take(3).toList();
          if (recent.isEmpty) {
            return Center(child: Text('No appointments', style: TextStyle(color: colors.textSecondary)));
          }
          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: recent.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final appointment = recent[index];
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: _getStatusColor(colors, appointment.status.name),
                    child: const Icon(Icons.event, color: Colors.white),
                  ),
                  title: Text(appointment.patientName),
                  subtitle: Text(appointment.doctorName),
                  trailing: _buildStatusBadge(colors, appointment.status.name),
                ),
              );
            },
          );
        }
        return Center(child: Text('No appointments', style: TextStyle(color: colors.textSecondary)));
      },
    );
  }

  Color _getStatusColor(AppColorSet colors, String status) {
    switch (status) {
      case 'scheduled':
        return colors.primary;
      case 'completed':
        return colors.success;
      case 'cancelled':
        return colors.error;
      case 'inProgress':
        return colors.accent;
      default:
        return colors.textLight;
    }
  }

  Widget _buildStatusBadge(AppColorSet colors, String status) {
    Color color;
    String label;
    switch (status) {
      case 'scheduled':
        color = colors.primary;
        label = 'Scheduled';
      case 'completed':
        color = colors.success;
        label = 'Completed';
      case 'cancelled':
        color = colors.error;
        label = 'Cancelled';
      case 'inProgress':
        color = colors.accent;
        label = 'In Progress';
      default:
        color = colors.textLight;
        label = status;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(label, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w500)),
    );
  }
}
