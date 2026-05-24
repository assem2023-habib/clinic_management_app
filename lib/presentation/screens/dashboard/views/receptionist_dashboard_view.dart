import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_routes.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/presentation/widgets/dashboard/action_button.dart';
import 'package:clinic_management_app/presentation/widgets/dashboard/dashboard_greeting.dart';
import 'package:clinic_management_app/presentation/widgets/dashboard/recent_appointments.dart';
import 'package:clinic_management_app/presentation/widgets/dashboard/stat_card.dart';
import 'package:clinic_management_app/presentation/widgets/animated_card.dart';

class ReceptionistDashboardView extends StatelessWidget {
  const ReceptionistDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedCard(index: 0, child: const DashboardGreeting()),
          const SizedBox(height: 24),
          AnimatedCard(
            index: 1,
            child: GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.5,
              children: [
                StatCard(title: AppStrings.todayAppts, icon: Icons.today, color: colors.primary),
                StatCard(title: AppStrings.newPatients, icon: Icons.person_add, color: colors.secondary),
                StatCard(title: AppStrings.pendingAppts, icon: Icons.pending_actions, color: colors.accent),
                StatCard(title: AppStrings.todayCompleted, icon: Icons.check_circle, color: colors.success),
              ],
            ),
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
                  Expanded(child: ActionButton(icon: Icons.person_add, label: AppStrings.registerPatient, color: colors.primary, onPressed: () => Navigator.pushNamed(context, AppRoutes.patients))),
                  const SizedBox(width: 12),
                  Expanded(child: ActionButton(icon: Icons.calendar_today, label: AppStrings.newAppointment, color: colors.secondary, onPressed: () => Navigator.pushNamed(context, AppRoutes.appointments))),
                ]),
                const SizedBox(height: 12),
                Row(children: [
                  Expanded(child: ActionButton(icon: Icons.schedule, label: AppStrings.todaySchedule, color: colors.accent, onPressed: () => Navigator.pushNamed(context, AppRoutes.appointments))),
                  const SizedBox(width: 12),
                  Expanded(child: ActionButton(icon: Icons.search, label: AppStrings.search, color: colors.primaryDark, onPressed: () => Navigator.pushNamed(context, AppRoutes.patients))),
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
                Text(AppStrings.todayAppts, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: colors.textPrimary)),
                const SizedBox(height: 12),
                const RecentAppointments(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
