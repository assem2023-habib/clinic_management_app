import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_routes.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/domain/entities/user_role.dart';
import 'package:clinic_management_app/core/utils/helpers.dart';
import 'package:clinic_management_app/presentation/blocs/auth/auth_cubit.dart';
import 'package:clinic_management_app/presentation/blocs/doctor_profile/doctor_profile_bloc.dart';
import 'package:clinic_management_app/presentation/blocs/doctor_profile/doctor_profile_event.dart';
import 'package:clinic_management_app/presentation/blocs/doctor_profile/doctor_profile_state.dart';
import 'package:clinic_management_app/presentation/widgets/skeleton/skeleton.dart';
import 'package:clinic_management_app/domain/repositories/doctor_repository.dart';
import 'package:clinic_management_app/presentation/screens/doctors/views/admin_doctor_profile_view.dart';
import 'package:clinic_management_app/presentation/screens/doctors/views/doctor_self_profile_view.dart';
import 'package:clinic_management_app/presentation/screens/doctors/views/patient_doctor_profile_view.dart';
import 'package:clinic_management_app/presentation/screens/doctors/views/receptionist_doctor_profile_view.dart';
import 'package:clinic_management_app/presentation/widgets/app_shell.dart';

class DoctorProfileScreen extends StatelessWidget {
  final String doctorId;

  const DoctorProfileScreen({super.key, required this.doctorId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DoctorProfileBloc(RepositoryProvider.of<DoctorRepository>(context))
        ..add(LoadDoctorProfile(doctorId)),
      child: BlocConsumer<DoctorProfileBloc, DoctorProfileState>(
        listener: (context, state) {
          if (state is DoctorProfileError) {
            showSnackBar(context, state.message, isError: true);
          }
        },
        builder: (context, state) {
          if (state is DoctorProfileLoading || state is DoctorProfileInitial) {
            return AppShell(
              currentRoute: AppRoutes.doctorProfile,
              showBackButton: true,
              title: AppStrings.doctorProfile,
              body: const SkeletonProfile(),
            );
          }

          if (state is DoctorProfileError) {
            return AppShell(
              currentRoute: AppRoutes.doctorProfile,
              showBackButton: true,
              title: AppStrings.doctorProfile,
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline_rounded, size: 48, color: AppColors.of(context).error),
                    const SizedBox(height: 16),
                    Text(state.message, style: const TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            );
          }

          if (state is DoctorProfileLoaded) {
            final role = context.read<AuthCubit>().state.role;
            final profile = state.profile;
            final doctor = profile.doctor;
            final isOwner = role == UserRole.doctor && doctor.id == doctorId;

            Widget body;
            if (role == UserRole.admin) {
              body = AdminDoctorProfileView(
                profile: profile,
                onToggleSlot: () {},
                onEditProfile: () {},
                onDeleteDoctor: () async {
                  final confirm = await showDeleteDialog(context);
                  if (confirm == true) {
                    Navigator.pop(context);
                  }
                },
              );
            } else if (role == UserRole.doctor && isOwner) {
              body = DoctorSelfProfileView(
                profile: profile,
                onToggleSlot: () {
                  // TODO: implement slot toggle
                },
              );
            } else if (role == UserRole.receptionist) {
              body = ReceptionistDoctorProfileView(
                profile: profile,
                onToggleSlot: () {},
              );
            } else {
              body = PatientDoctorProfileView(
                profile: profile,
                onBookAppointment: () => Navigator.pushNamed(
                  context,
                  AppRoutes.userBooking,
                  arguments: doctor.id,
                ),
              );
            }

            return AppShell(
              currentRoute: AppRoutes.doctorProfile,
              showBackButton: true,
              title: doctor.name,
              body: body,
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
