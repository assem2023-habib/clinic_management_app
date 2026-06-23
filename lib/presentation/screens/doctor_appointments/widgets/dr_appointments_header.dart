import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/presentation/blocs/auth/auth_cubit.dart';

class DrAppointmentsHeader extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onNotificationTap;

  const DrAppointmentsHeader({super.key, this.onNotificationTap});

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final name = state.userName ?? AppStrings.roleDoctor;
        final hour = DateTime.now().hour;
        final greeting = hour < 12 ? AppStrings.rhGreetingMorning : AppStrings.rhGreetingEvening;

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.md),
          decoration: BoxDecoration(
            color: colors.appBarBg.withValues(alpha: 0.7),
            border: Border(bottom: BorderSide(color: colors.divider.withValues(alpha: 0.1))),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: colors.primary.withValues(alpha: 0.2)),
                  color: colors.primary.withValues(alpha: 0.1),
                ),
                child: Icon(Icons.person_rounded, color: colors.primary, size: AppSpacing.iconMedium),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$greeting،',
                      style: TextStyle(fontSize: AppSpacing.bodySmall, color: colors.textSecondary),
                    ),
                    Text(
                      name,
                      style: TextStyle(fontSize: AppSpacing.heading, fontWeight: FontWeight.w700, color: colors.textPrimary),
                    ),
                  ],
                ),
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(AppSpacing.lg - AppSpacing.xs),
                  onTap: onNotificationTap,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colors.cardBg.withValues(alpha: 0.5),
                    ),
                    child: Icon(Icons.notifications_outlined, color: colors.textSecondary, size: AppSpacing.iconMedium),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
