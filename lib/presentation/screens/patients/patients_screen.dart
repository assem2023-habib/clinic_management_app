import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clinic_management_app/core/constants/app_routes.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/presentation/blocs/auth/auth_cubit.dart';
import 'package:clinic_management_app/domain/entities/user_role.dart';
import 'package:clinic_management_app/presentation/blocs/patient/patient_bloc.dart';
import 'package:clinic_management_app/presentation/blocs/patient/patient_event.dart';
import 'package:clinic_management_app/presentation/screens/patients/views/admin_patients_view.dart';
import 'package:clinic_management_app/presentation/screens/patients/views/doctor_patients_view.dart';
import 'package:clinic_management_app/presentation/screens/patients/views/receptionist_patients_view.dart';
import 'package:clinic_management_app/presentation/widgets/app_shell.dart';
import 'package:clinic_management_app/presentation/widgets/patient_form_dialog.dart';
import 'package:clinic_management_app/core/constants/app_icons.dart';

class PatientsScreen extends StatefulWidget {
  const PatientsScreen({super.key});

  @override
  State<PatientsScreen> createState() => _PatientsScreenState();
}

class _PatientsScreenState extends State<PatientsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PatientBloc>().add(PatientLoadAll());
  }

  @override
  Widget build(BuildContext context) {
    final role = context.watch<AuthCubit>().state.role;
    final title = switch (role) {
      UserRole.doctor => AppStrings.myPatients,
      _ => AppStrings.patients,
    };
    final isAdmin = role == UserRole.admin;
    return AppShell(
      title: title,
      currentRoute: AppRoutes.patients,
      floatingActionButton: isAdmin
          ? FloatingActionButton(
              onPressed: _showAddPatientDialog,
              child: const Icon(AppIcons.add),
            )
          : null,
      body: switch (role) {
        UserRole.admin => const AdminPatientsView(),
        UserRole.doctor => const DoctorPatientsView(),
        UserRole.receptionist => const ReceptionistPatientsView(),
        _ => const SizedBox.shrink(),
      },
    );
  }

  void _showAddPatientDialog() {
    showDialog(
      context: context,
      builder: (_) => const PatientFormDialog(),
    );
  }
}
