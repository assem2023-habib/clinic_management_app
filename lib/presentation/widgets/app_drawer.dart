import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_routes.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/core/theme/theme_provider.dart';
import 'package:clinic_management_app/presentation/blocs/auth/auth_cubit.dart';
import 'package:clinic_management_app/presentation/blocs/language/language_cubit.dart';
import 'package:clinic_management_app/presentation/blocs/notification/notification_bloc.dart';
import 'package:clinic_management_app/presentation/blocs/notification/notification_state.dart';
import 'package:clinic_management_app/domain/entities/user_role.dart';
import 'package:clinic_management_app/core/constants/app_icons.dart';

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
          _buildLanguageToggle(context, colors),
          _buildLogout(context, colors),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppColorSet colors) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final name = state.userName ?? AppStrings.roleUser;
        final initials = name.isNotEmpty ? name[0] : AppStrings.defaultInitial; // fallback char
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
                    fontSize: AppSpacing.titleError,
                    fontWeight: FontWeight.bold,
                    color: colors.primaryDark,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.sm + AppSpacing.xs),
              Text(
                name,
                style: const TextStyle(
                  fontSize: AppSpacing.titleMedium,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: AppSpacing.xxs),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.ten, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppSpacing.lg - AppSpacing.xs),
                ),
                child: Text(
                  roleLabel,
                  style: const TextStyle(fontSize: AppSpacing.bodySmall, color: Colors.white, fontWeight: FontWeight.w600),
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
      _MenuItem(icon: AppIcons.dashboard, title: AppStrings.dashboard, route: AppRoutes.dashboard),
      _MenuItem(icon: AppIcons.notifications, title: AppStrings.notifications, route: AppRoutes.notifications),
      _MenuItem(icon: AppIcons.localHospital, title: AppStrings.doctors, route: AppRoutes.doctors),
      _MenuItem(icon: AppIcons.people, title: patientsLabel, route: AppRoutes.patients),
      _MenuItem(icon: AppIcons.calendarMonth, title: AppStrings.myAppointments, route: AppRoutes.myAppointments),
      _MenuItem(icon: AppIcons.folder, title: AppStrings.medicalRecords, route: AppRoutes.medicalRecords),
      _MenuItem(icon: AppIcons.settings, title: AppStrings.settings, route: AppRoutes.settings),
      _MenuItem(icon: AppIcons.person, title: AppStrings.myProfile, route: AppRoutes.profile),
      _MenuItem(icon: AppIcons.supervisorAccount, title: AppStrings.supervisionRequests, route: AppRoutes.supervisionRequests),
      _MenuItem(icon: AppIcons.star, title: AppStrings.appRatings, route: AppRoutes.rating, arguments: {'isAppRating': true}),
    ];

    final roleRoutes = <UserRole, Set<String>>{
      UserRole.admin:        {AppRoutes.dashboard, AppRoutes.notifications, AppRoutes.doctors, AppRoutes.patients, AppRoutes.appointments, AppRoutes.medicalRecords, AppRoutes.settings, AppRoutes.profile, AppRoutes.rating},
      UserRole.doctor:       {AppRoutes.dashboard, AppRoutes.notifications, AppRoutes.patients, AppRoutes.appointments, AppRoutes.medicalRecords, AppRoutes.settings, AppRoutes.profile, AppRoutes.supervisionRequests, AppRoutes.rating},
      UserRole.receptionist: {AppRoutes.dashboard, AppRoutes.notifications, AppRoutes.doctors, AppRoutes.patients, AppRoutes.appointments, AppRoutes.medicalRecords, AppRoutes.settings, AppRoutes.profile, AppRoutes.rating},
      UserRole.patient:      {AppRoutes.dashboard, AppRoutes.notifications, AppRoutes.doctors, AppRoutes.myAppointments, AppRoutes.medicalRecords, AppRoutes.settings, AppRoutes.profile, AppRoutes.supervisionRequests, AppRoutes.rating},
    };

    final allowed = roleRoutes[role] ?? roleRoutes[UserRole.patient]!;
    final items = allItems.where((item) => allowed.contains(item.route)).toList();

    return ListView(
      padding: EdgeInsets.only(top: AppSpacing.sm),
      children: items.map((item) {
        final isActive = currentRoute == item.route;
        final isNotification = item.route == AppRoutes.notifications;
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xxs),
          child: ListTile(
            tileColor: isActive ? colors.primary.withValues(alpha: 0.1) : null,
            leading: isNotification
                ? _NotificationBadge(icon: item.icon, color: isActive ? colors.primary : colors.textSecondary)
                : Icon(item.icon, color: isActive ? colors.primary : colors.textSecondary, size: AppSpacing.iconMedium),
            title: Text(
              item.title,
              style: TextStyle(
                fontSize: AppSpacing.subtitle,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                color: isActive ? colors.primary : colors.textPrimary,
              ),
            ),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.buttonRadius)),
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
            leading: Icon(isDark ? AppIcons.darkMode : AppIcons.lightMode, color: colors.primary, size: AppSpacing.iconMedium),
            title: Text(
              isDark ? AppStrings.darkMode : AppStrings.lightMode,
              style: TextStyle(fontSize: AppSpacing.subtitle, fontWeight: FontWeight.w500, color: colors.textPrimary),
            ),
            onTap: () => themeProvider!.toggleTheme(),
          ),
        );
      },
    );
  }

  Widget _buildLanguageToggle(BuildContext context, AppColorSet colors) {
    final locale = context.watch<LanguageCubit>().state;
    final isEn = locale.languageCode == 'en';
    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: colors.divider.withValues(alpha: 0.3))),
      ),
      child: ListTile(
        leading: const Icon(AppIcons.language, size: AppSpacing.iconMedium),
        title: Text(
          isEn ? AppStrings.english : AppStrings.arabic,
          style: TextStyle(fontSize: AppSpacing.subtitle, fontWeight: FontWeight.w500, color: colors.textPrimary),
        ),
        trailing: Text(
          isEn ? '🇬🇧' : '🇸🇦',
          style: const TextStyle(fontSize: AppSpacing.bodyLarge),
        ),
        onTap: () {
          context.read<LanguageCubit>().setLocale(isEn ? 'ar' : 'en');
        },
      ),
    );
  }

  Widget _buildLogout(BuildContext context, AppColorSet colors) {
    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: colors.divider.withValues(alpha: 0.3))),
      ),
      child: ListTile(
        leading: Icon(AppIcons.logout, color: colors.error, size: AppSpacing.iconMedium),
        title: Text(
          AppStrings.logout,
          style: TextStyle(
            fontSize: AppSpacing.subtitle,
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

class _NotificationBadge extends StatelessWidget {
  final IconData icon;
  final Color color;
  const _NotificationBadge({required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationBloc, NotificationState>(
      builder: (context, state) {
        final unread = state is NotificationLoaded ? state.unreadCount : 0;
        if (unread > 0) {
          return Badge(
            label: Text(unread > 99 ? '99+' : '$unread', style: const TextStyle(fontSize: AppSpacing.ten)),
            child: Icon(icon, color: color, size: AppSpacing.iconMedium),
          );
        }
        return Icon(icon, color: color, size: AppSpacing.iconMedium);
      },
    );
  }
}
