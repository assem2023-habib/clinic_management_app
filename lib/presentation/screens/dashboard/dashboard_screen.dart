import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/core/constants/app_routes.dart';
import 'package:clinic_management_app/core/theme/theme_provider.dart';
import 'package:clinic_management_app/presentation/blocs/auth/auth_cubit.dart';
import 'package:clinic_management_app/presentation/blocs/dashboard/dashboard_bloc.dart';
import 'package:clinic_management_app/presentation/blocs/dashboard/dashboard_event.dart';
import 'package:clinic_management_app/presentation/blocs/notification/notification_bloc.dart';
import 'package:clinic_management_app/presentation/blocs/notification/notification_event.dart';
import 'package:clinic_management_app/presentation/blocs/notification/notification_state.dart';
import 'package:clinic_management_app/domain/entities/user_role.dart';
import 'package:clinic_management_app/presentation/widgets/app_shell.dart';
import 'package:clinic_management_app/presentation/screens/dashboard/views/admin_dashboard_view.dart';
import 'package:clinic_management_app/presentation/screens/dashboard/views/doctor_dashboard_view.dart';
import 'package:clinic_management_app/presentation/screens/dashboard/views/receptionist_dashboard_view.dart';
import 'package:clinic_management_app/presentation/screens/dashboard/views/patient_dashboard_view.dart';

class DashboardScreen extends StatefulWidget {
  final ThemeProvider? themeProvider;

  const DashboardScreen({super.key, this.themeProvider});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    context.read<DashboardBloc>().add(DashboardLoad());
    context.read<NotificationBloc>().add(const NotificationLoadAll(limit: 1));
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final role = context.watch<AuthCubit>().state.role;
    final notifState = context.watch<NotificationBloc>().state;
    final unreadCount = notifState is NotificationLoaded ? notifState.unreadCount : 0;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        _showExitDialog(context, colors);
      },
      child: AppShell(
        themeProvider: widget.themeProvider,
        title: AppStrings.dashboard,
        currentRoute: AppRoutes.dashboard,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () => Navigator.pushNamed(context, AppRoutes.notifications),
              ),
              if (unreadCount > 0)
                Positioned(
                  top: 6,
                  right: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                    decoration: BoxDecoration(
                      color: colors.neonGreen,
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: colors.surface, width: 1.5),
                    ),
                    constraints: const BoxConstraints(minWidth: 16, minHeight: 14),
                    child: Text(
                      unreadCount > 99 ? '99+' : '$unreadCount',
                      style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
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
