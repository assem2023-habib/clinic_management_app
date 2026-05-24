import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/core/constants/app_routes.dart';
import 'package:clinic_management_app/core/theme/theme_provider.dart';
import 'package:clinic_management_app/presentation/blocs/auth/auth_cubit.dart';
import 'package:clinic_management_app/domain/entities/user_role.dart';
import 'package:clinic_management_app/presentation/widgets/app_shell.dart';
import 'package:clinic_management_app/presentation/screens/dashboard/views/admin_dashboard_view.dart';
import 'package:clinic_management_app/presentation/screens/dashboard/views/doctor_dashboard_view.dart';
import 'package:clinic_management_app/presentation/screens/dashboard/views/receptionist_dashboard_view.dart';
import 'package:clinic_management_app/presentation/screens/dashboard/views/patient_dashboard_view.dart';

class DashboardScreen extends StatelessWidget {
  final ThemeProvider? themeProvider;

  const DashboardScreen({super.key, this.themeProvider});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final role = context.watch<AuthCubit>().state.role;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        _showExitDialog(context, colors);
      },
      child: AppShell(
        themeProvider: themeProvider,
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
      ),
    );
  }

  void _showExitDialog(BuildContext context, AppColorSet colors) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: colors.cardBg,
        title: Text(AppStrings.confirmExit, style: TextStyle(color: colors.textPrimary)),
        content: Text(AppStrings.confirmExitMessage, style: TextStyle(color: colors.textSecondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(AppStrings.cancel, style: TextStyle(color: colors.primary)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              SystemNavigator.pop();
            },
            child: Text(AppStrings.exit, style: TextStyle(color: colors.error)),
          ),
        ],
      ),
    );
  }
}
