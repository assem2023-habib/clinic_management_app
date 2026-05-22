import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/core/constants/app_routes.dart';
import 'package:clinic_management_app/presentation/blocs/auth/auth_cubit.dart';
import 'package:clinic_management_app/domain/entities/user_role.dart';
import 'package:clinic_management_app/presentation/widgets/app_shell.dart';
import 'package:clinic_management_app/presentation/screens/dashboard/views/admin_dashboard_view.dart';
import 'package:clinic_management_app/presentation/screens/dashboard/views/doctor_dashboard_view.dart';
import 'package:clinic_management_app/presentation/screens/dashboard/views/receptionist_dashboard_view.dart';
import 'package:clinic_management_app/presentation/screens/dashboard/views/patient_dashboard_view.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final role = context.watch<AuthCubit>().state.role;
    return AppShell(
      title: AppStrings.dashboard,
      currentRoute: AppRoutes.dashboard,
      actions: [
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () {
            context.read<AuthCubit>().logout();
            Navigator.pushReplacementNamed(context, AppRoutes.login);
          },
        ),
      ],
      body: switch (role) {
        UserRole.admin => const AdminDashboardView(),
        UserRole.doctor => const DoctorDashboardView(),
        UserRole.receptionist => const ReceptionistDashboardView(),
        UserRole.patient => const PatientDashboardView(),
        null => const AdminDashboardView(),
      },
    );
  }
}
