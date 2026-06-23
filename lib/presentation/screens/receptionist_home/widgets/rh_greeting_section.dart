import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/presentation/blocs/auth/auth_cubit.dart';

class RhGreetingSection extends StatelessWidget {
  const RhGreetingSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final userName = state.userName ?? '';
        final hour = DateTime.now().hour;
        final greeting = hour < 12 ? AppStrings.rhGreetingMorning : AppStrings.rhGreetingEvening;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$greeting، $userName',
              style: TextStyle(
                fontSize: AppSpacing.bodyMedium,
                fontWeight: FontWeight.w600,
                color: colors.secondary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              AppStrings.rhClinicName,
              style: TextStyle(
                fontSize: AppSpacing.titleError,
                fontWeight: FontWeight.w700,
                color: colors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: colors.success,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  '${AppStrings.rhSystemStatus} • ${AppStrings.rhReceptionDesk}',
                  style: TextStyle(
                    fontSize: AppSpacing.bodySmall,
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
