import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clinic_management_app/core/constants/app_routes.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/presentation/blocs/auth/auth_cubit.dart';
import 'package:clinic_management_app/domain/entities/user_role.dart';
import 'package:clinic_management_app/presentation/blocs/patient/patient_bloc.dart';
import 'package:clinic_management_app/presentation/blocs/patient/patient_event.dart';
import 'package:clinic_management_app/presentation/widgets/app_shell.dart';
import 'package:clinic_management_app/presentation/screens/patients/views/admin_patients_view.dart';
import 'package:clinic_management_app/presentation/screens/patients/views/doctor_patients_view.dart';
import 'package:clinic_management_app/presentation/screens/patients/views/receptionist_patients_view.dart';

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
    final canManage = role == UserRole.admin || role == UserRole.receptionist;
    return AppShell(
      title: AppStrings.patients,
      currentRoute: AppRoutes.patients,
      floatingActionButton: canManage
          ? FloatingActionButton(onPressed: () {}, child: const Icon(Icons.add))
          : null,
      body: switch (role) {
        UserRole.admin => const AdminPatientsView(),
        UserRole.doctor => const DoctorPatientsView(),
        UserRole.receptionist => const ReceptionistPatientsView(),
        UserRole.patient => const DoctorPatientsView(),
        null => const AdminPatientsView(),
      },
    );
  }
}
