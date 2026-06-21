import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_routes.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/presentation/blocs/auth/auth_cubit.dart';
import 'package:clinic_management_app/presentation/blocs/doctor/doctor_bloc.dart';
import 'package:clinic_management_app/presentation/blocs/doctor/doctor_event.dart';
import 'package:clinic_management_app/presentation/blocs/doctor/doctor_state.dart';
import 'package:clinic_management_app/presentation/widgets/app_shell.dart';
import 'package:clinic_management_app/presentation/widgets/doctor_glass_card.dart';

class MyAppointmentsScreen extends StatefulWidget {
  const MyAppointmentsScreen({super.key});

  @override
  State<MyAppointmentsScreen> createState() => _MyAppointmentsScreenState();
}

class _MyAppointmentsScreenState extends State<MyAppointmentsScreen> {
  @override
  void initState() {
    super.initState();
    final patientId = context.read<AuthCubit>().state.userId;
    if (patientId != null) {
      context.read<DoctorBloc>().add(DoctorLoadPatientAppointments(patientId));
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return AppShell(
      showDrawer: true,
      currentRoute: AppRoutes.myAppointments,
      extendBody: true,
      useGlassAppBar: true,
      glassTitle: AppStrings.myAppointments,
      showParticleBg: true,
      body: BlocBuilder<DoctorBloc, DoctorState>(
        builder: (context, state) {
          if (state is DoctorLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is DoctorError) {
            return Center(
              child: Text(state.message, style: TextStyle(color: colors.error)),
            );
          }
          if (state is DoctorLoaded) {
            final doctors = state.doctors;
            if (doctors.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.calendar_month_rounded, size: 64, color: colors.textSecondary.withValues(alpha: 0.3)),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'لا توجد مواعيد حالياً',
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: colors.textSecondary),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'احجز موعداً مع أحد أطبائنا',
                      style: TextStyle(fontSize: AppSpacing.bodyMedium, color: colors.textSecondary.withValues(alpha: 0.6)),
                    ),
                  ],
                ),
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.md, AppSpacing.md, 100),
              itemCount: doctors.length,
              separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
              itemBuilder: (_, i) {
                final doctor = doctors[i];
                return DoctorGlassCard(
                  doctor: doctor,
                  animDelay: Duration(milliseconds: 80 * i),
                  showMore: false,
                  showSupervision: false,
                  onBook: () => Navigator.pushNamed(
                    context, AppRoutes.userBooking, arguments: doctor.id),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
