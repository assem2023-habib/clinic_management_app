import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clinic_management_app/core/constants/app_routes.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/presentation/blocs/auth/auth_cubit.dart';
import 'package:clinic_management_app/domain/entities/user_role.dart';
import 'package:clinic_management_app/presentation/screens/appointment_confirmation/confirmation_data.dart';
import 'package:clinic_management_app/presentation/widgets/appointment_form_dialog.dart';
import 'package:clinic_management_app/presentation/widgets/app_shell.dart';
import 'package:clinic_management_app/presentation/blocs/appointment/appointment_bloc.dart';
import 'package:clinic_management_app/presentation/blocs/appointment/appointment_event.dart';
import 'package:clinic_management_app/presentation/blocs/doctor/doctor_bloc.dart';
import 'package:clinic_management_app/presentation/blocs/doctor/doctor_event.dart';
import 'package:clinic_management_app/presentation/screens/appointments/views/admin_appointments_view.dart';
import 'package:clinic_management_app/presentation/screens/appointments/views/doctor_appointments_view.dart';
import 'package:clinic_management_app/presentation/screens/appointments/views/receptionist_appointments_view.dart';
import 'package:clinic_management_app/presentation/screens/appointments/views/patient_appointments_view.dart';
import 'package:clinic_management_app/presentation/screens/doctor_appointments/widgets/dr_appointments_header.dart';

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
    context.read<DoctorBloc>().add(DoctorLoadAll());
  }

  @override
  Widget build(BuildContext context) {
    final role = context.watch<AuthCubit>().state.role;
    final isDoctor = role == UserRole.doctor;

    return AppShell(
      showDrawer: true,
      currentRoute: AppRoutes.appointments,
      extendBody: true,
      useGlassAppBar: !isDoctor,
      showParticleBg: true,
      starMode: true,
      particleCount: 60,
      glassTitle: AppStrings.myAppointments,
      customHeader: isDoctor ? const DrAppointmentsHeader() : null,
      body: switch (role) {
        UserRole.admin => const AdminAppointmentsView(),
        UserRole.doctor => const DoctorAppointmentsView(),
        UserRole.receptionist => const ReceptionistAppointmentsView(),
        UserRole.patient => const PatientAppointmentsView(),
        null => const AdminAppointmentsView(),
      },
      floatingActionButton: switch (role) {
        UserRole.admin || UserRole.receptionist => FloatingActionButton(
          onPressed: () async {
            final result = await showDialog<ConfirmationData>(context: context, builder: (_) => const AppointmentFormDialog());
            if (result != null && context.mounted) {
              Navigator.pushNamed(context, AppRoutes.appointmentConfirmation, arguments: result);
            }
          },
          child: const Icon(Icons.add),
        ),
        _ => null,
      },
    );
  }
}
