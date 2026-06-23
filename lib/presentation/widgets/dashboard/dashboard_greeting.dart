import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/presentation/blocs/auth/auth_cubit.dart';
import 'package:clinic_management_app/domain/entities/user_role.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';

class DashboardGreeting extends StatelessWidget {
  const DashboardGreeting({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final roleLabel = switch (state.role) {
          UserRole.admin => AppStrings.roleAdmin,
          UserRole.doctor => AppStrings.roleDoctor,
          UserRole.receptionist => AppStrings.roleReceptionist,
          UserRole.patient => AppStrings.rolePatient,
          null => AppStrings.roleUser,
        };
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${AppStrings.greeting} ${state.userName ?? ''}',
              style: TextStyle(fontSize: AppSpacing.titleError, fontWeight: FontWeight.bold, color: colors.textPrimary),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              roleLabel,
              style: TextStyle(fontSize: AppSpacing.bodyMedium, color: colors.primary, fontWeight: FontWeight.w600),
            ),
          ],
        );
      },
    );
  }
}

