import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_routes.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/core/theme/theme_provider.dart';
import 'package:clinic_management_app/presentation/blocs/auth/auth_cubit.dart';
import 'package:clinic_management_app/domain/entities/user_role.dart';

class AppDrawer extends StatelessWidget {
  final String? currentRoute;
  final ThemeProvider? themeProvider;

  const AppDrawer({super.key, this.currentRoute, this.themeProvider});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Drawer(
      backgroundColor: colors.cardBg,
      child: Column(
        children: [
          _buildHeader(context, colors),
          Expanded(
            child: _buildMenuItems(context, colors),
          ),
          _buildThemeToggle(context, colors),
          _buildLogout(context, colors),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppColorSet colors) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final name = state.userName ?? AppStrings.roleUser;
        final initials = name.isNotEmpty ? name[0] : 'م';
        final roleLabel = _roleLabel(state.role);
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [colors.primary, colors.primaryDark],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + AppSpacing.lg,
            bottom: AppSpacing.lg,
            left: AppSpacing.md,
            right: AppSpacing.md,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: colors.primaryLight,
                child: Text(
                  initials,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: colors.primaryDark,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 2),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  roleLabel,
                  style: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMenuItems(BuildContext context, AppColorSet colors) {
    final role = context.watch<AuthCubit>().state.role;
    final patientsLabel = role == UserRole.doctor ? AppStrings.myPatients : AppStrings.patients;
    final allItems = [
      _MenuItem(icon: Icons.dashboard_rounded, title: AppStrings.dashboard, route: AppRoutes.dashboard),
      _MenuItem(icon: Icons.local_hospital_rounded, title: AppStrings.doctors, route: AppRoutes.doctors),
      _MenuItem(icon: Icons.people_rounded, title: patientsLabel, route: AppRoutes.patients),
      _MenuItem(icon: Icons.calendar_month_rounded, title: AppStrings.myAppointments, route: AppRoutes.myAppointments),
      _MenuItem(icon: Icons.folder_rounded, title: AppStrings.medicalRecords, route: AppRoutes.medicalRecords),
      _MenuItem(icon: Icons.settings_rounded, title: AppStrings.settings, route: AppRoutes.settings),
      _MenuItem(icon: Icons.person_rounded, title: AppStrings.myProfile, route: AppRoutes.profile),
      _MenuItem(icon: Icons.supervisor_account_rounded, title: AppStrings.supervisionRequests, route: AppRoutes.supervisionRequests),
      _MenuItem(icon: Icons.star_rounded, title: AppStrings.appRatings, route: AppRoutes.rating, arguments: {'isAppRating': true}),
    ];

    final roleRoutes = <UserRole, Set<String>>{
      UserRole.admin:        {AppRoutes.dashboard, AppRoutes.doctors, AppRoutes.patients, AppRoutes.appointments, AppRoutes.medicalRecords, AppRoutes.settings, AppRoutes.profile, AppRoutes.rating},
      UserRole.doctor:       {AppRoutes.dashboard, AppRoutes.patients, AppRoutes.appointments, AppRoutes.medicalRecords, AppRoutes.settings, AppRoutes.profile, AppRoutes.supervisionRequests, AppRoutes.rating},
      UserRole.receptionist: {AppRoutes.dashboard, AppRoutes.doctors, AppRoutes.patients, AppRoutes.appointments, AppRoutes.medicalRecords, AppRoutes.settings, AppRoutes.profile, AppRoutes.rating},
      UserRole.patient:      {AppRoutes.dashboard, AppRoutes.doctors, AppRoutes.myAppointments, AppRoutes.medicalRecords, AppRoutes.settings, AppRoutes.profile, AppRoutes.supervisionRequests, AppRoutes.rating},
    };

    final allowed = roleRoutes[role] ?? roleRoutes[UserRole.patient]!;
    final items = allItems.where((item) => allowed.contains(item.route)).toList();

    return ListView(
      padding: EdgeInsets.only(top: AppSpacing.sm),
      children: items.map((item) {
        final isActive = currentRoute == item.route;
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 2),
          child: ListTile(
            tileColor: isActive ? colors.primary.withValues(alpha: 0.1) : null,
            leading: Icon(
              item.icon,
              color: isActive ? colors.primary : colors.textSecondary,
              size: 22,
            ),
            title: Text(
              item.title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                color: isActive ? colors.primary : colors.textPrimary,
              ),
            ),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            onTap: () {
              Navigator.pop(context);
              if (currentRoute != item.route) {
                Navigator.pushNamed(context, item.route, arguments: item.arguments);
              }
            },
          ),
        );
      }).toList(),
    );
  }

  Widget _buildThemeToggle(BuildContext context, AppColorSet colors) {
    if (themeProvider == null) return const SizedBox.shrink();
    return ListenableBuilder(
      listenable: themeProvider!,
      builder: (context, _) {
        final isDark = themeProvider!.isDarkMode;
        return Container(
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: colors.divider.withValues(alpha: 0.3))),
          ),
          child: ListTile(
            leading: Icon(isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded, color: colors.primary, size: 22),
            title: Text(
              isDark ? AppStrings.darkMode : AppStrings.lightMode,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: colors.textPrimary),
            ),
            onTap: () => themeProvider!.toggleTheme(),
          ),
        );
      },
    );
  }

  Widget _buildLogout(BuildContext context, AppColorSet colors) {
    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: colors.divider.withValues(alpha: 0.3))),
      ),
      child: ListTile(
        leading: Icon(Icons.logout_rounded, color: colors.error, size: 22),
        title: Text(
          AppStrings.logout,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: colors.error,
          ),
        ),
        onTap: () {
          context.read<AuthCubit>().logout();
          Navigator.pushReplacementNamed(context, AppRoutes.login);
        },
      ),
    );
  }

  String _roleLabel(UserRole? role) {
    return switch (role) {
      UserRole.admin => AppStrings.roleAdmin,
      UserRole.doctor => AppStrings.roleDoctor,
      UserRole.receptionist => AppStrings.roleReceptionist,
      UserRole.patient => AppStrings.rolePatient,
      null => AppStrings.roleUser,
    };
  }
}

class _MenuItem {
  final IconData icon;
  final String title;
  final String route;
  final Object? arguments;
  const _MenuItem({required this.icon, required this.title, required this.route, this.arguments});
}
