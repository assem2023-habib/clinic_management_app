import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clinic_management_app/core/constants/app_routes.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/presentation/blocs/auth/auth_cubit.dart';
import 'package:clinic_management_app/domain/entities/user_role.dart';
import 'package:clinic_management_app/presentation/widgets/app_shell.dart';
import 'package:clinic_management_app/presentation/screens/medical_records/views/doctor_records_view.dart';
import 'package:clinic_management_app/presentation/screens/medical_records/views/patient_records_view.dart';

class MedicalRecordsScreen extends StatefulWidget {
  const MedicalRecordsScreen({super.key});

  @override
  State<MedicalRecordsScreen> createState() => _MedicalRecordsScreenState();
}

class _MedicalRecordsScreenState extends State<MedicalRecordsScreen> {
  @override
  Widget build(BuildContext context) {
    final role = context.watch<AuthCubit>().state.role;
    return AppShell(
      title: AppStrings.medicalRecordsTitle,
      currentRoute: AppRoutes.medicalRecords,
      body: switch (role) {
        UserRole.doctor || UserRole.admin || UserRole.receptionist => const DoctorRecordsView(),
        UserRole.patient => const PatientRecordsView(),
        null => const DoctorRecordsView(),
      },
    );
  }
}
