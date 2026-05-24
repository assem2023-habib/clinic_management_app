import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';
import 'package:clinic_management_app/domain/entities/user_role.dart';
import 'package:clinic_management_app/presentation/blocs/auth/auth_cubit.dart';
import 'package:clinic_management_app/presentation/screens/appointment_confirmation/confirmation_data.dart';
import 'package:clinic_management_app/presentation/screens/appointment_confirmation/widgets/confirmation_header.dart';
import 'package:clinic_management_app/presentation/screens/appointment_confirmation/widgets/confirmation_details_card.dart';
import 'package:clinic_management_app/presentation/screens/appointment_confirmation/widgets/confirmation_instructions.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/presentation/screens/appointment_confirmation/widgets/confirmation_actions.dart';

class AppointmentConfirmationScreen extends StatelessWidget {
  final ConfirmationData data;

  const AppointmentConfirmationScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final role = context.watch<AuthCubit>().state.role ?? UserRole.patient;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(AppStrings.confirmAppointment),
        actions: [
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: colors.primary.withValues(alpha: 0.15),
              child: Icon(Icons.person_rounded, size: 20, color: colors.primary),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.sm, AppSpacing.md, 100),
        child: Column(
          children: [
            ConfirmationHeader(role: role),
            const SizedBox(height: AppSpacing.xl),
            ConfirmationDetailsCard(data: data),
            const SizedBox(height: AppSpacing.lg),
            const ConfirmationInstructions(),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(
          left: AppSpacing.md,
          right: AppSpacing.md,
          top: 12,
          bottom: MediaQuery.of(context).padding.bottom + AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: colors.surface.withValues(alpha: 0.7),
          border: Border(top: BorderSide(color: colors.divider.withValues(alpha: 0.1))),
        ),
        child: ConfirmationActions(
          role: role,
          doctorId: data.doctor.id,
          onAddToCalendar: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text(AppStrings.addedToCalendar)),
            );
          },
        ),
      ),
    );
  }
}
