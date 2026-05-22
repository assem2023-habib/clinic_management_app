import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clinic_management_app/core/constants/app_routes.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/presentation/blocs/auth/auth_cubit.dart';
import 'package:clinic_management_app/domain/entities/user_role.dart';
import 'package:clinic_management_app/presentation/widgets/app_shell.dart';
import 'package:clinic_management_app/presentation/blocs/appointment/appointment_bloc.dart';
import 'package:clinic_management_app/presentation/blocs/appointment/appointment_event.dart';
import 'package:clinic_management_app/presentation/screens/appointments/views/admin_appointments_view.dart';
import 'package:clinic_management_app/presentation/screens/appointments/views/doctor_appointments_view.dart';
import 'package:clinic_management_app/presentation/screens/appointments/views/receptionist_appointments_view.dart';
import 'package:clinic_management_app/presentation/screens/appointments/views/patient_appointments_view.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AppointmentBloc>().add(AppointmentLoadAll());
  }

  @override
  Widget build(BuildContext context) {
    final role = context.watch<AuthCubit>().state.role;
    return AppShell(
      title: AppStrings.appointments,
      currentRoute: AppRoutes.appointments,
      floatingActionButton: switch (role) {
        UserRole.admin || UserRole.receptionist => FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.add),
        ),
        _ => null,
      },
      body: switch (role) {
        UserRole.admin => const AdminAppointmentsView(),
        UserRole.doctor => const DoctorAppointmentsView(),
        UserRole.receptionist => const ReceptionistAppointmentsView(),
        UserRole.patient => const PatientAppointmentsView(),
        null => const AdminAppointmentsView(),
      },
    );
  }
}
