import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/presentation/blocs/auth/auth_cubit.dart';
import 'package:clinic_management_app/domain/entities/user_role.dart';

class DashboardGreeting extends StatelessWidget {
  const DashboardGreeting({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final roleLabel = switch (state.role) {
          UserRole.admin => 'مُدِير العِيَادَة',
          UserRole.doctor => 'طَبِيب',
          UserRole.receptionist => 'مَسْؤُول الاسْتِقْبَال',
          UserRole.patient => 'مَرِيض',
          null => 'مُسْتَخْدِم',
        };
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'مَرْحَباً، ${state.userName ?? ''}',
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
    );
  }
}
