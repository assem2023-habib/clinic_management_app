import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_routes.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
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
                StatCard(title: AppStrings.upcomingAppts, icon: Icons.event, color: colors.primary),
                StatCard(title: AppStrings.previousVisits, icon: Icons.history, color: colors.secondary),
                StatCard(title: AppStrings.medicalRecords, icon: Icons.folder, color: colors.accent),
                StatCard(title: AppStrings.invoices, icon: Icons.receipt, color: colors.primaryDark),
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
}
