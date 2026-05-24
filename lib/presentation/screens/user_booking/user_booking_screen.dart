import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_routes.dart';
import 'package:clinic_management_app/domain/entities/user_role.dart';
import 'package:clinic_management_app/domain/repositories/appointment_repository.dart';
import 'package:clinic_management_app/domain/repositories/doctor_repository.dart';
import 'package:clinic_management_app/presentation/blocs/auth/auth_cubit.dart';
import 'package:clinic_management_app/presentation/blocs/user_booking/user_booking_bloc.dart';
import 'package:clinic_management_app/presentation/blocs/user_booking/user_booking_event.dart';
import 'package:clinic_management_app/presentation/blocs/user_booking/user_booking_state.dart';
import 'package:clinic_management_app/presentation/screens/appointment_confirmation/confirmation_data.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/presentation/screens/user_booking/widgets/date_selection_bar.dart';
import 'package:clinic_management_app/presentation/screens/user_booking/widgets/doctor_booking_card.dart';
import 'package:clinic_management_app/presentation/screens/user_booking/widgets/time_slot_grid.dart';
import 'package:clinic_management_app/presentation/screens/user_booking/widgets/confirm_booking_bar.dart';

class UserBookingScreen extends StatelessWidget {
  final String doctorId;

  const UserBookingScreen({super.key, required this.doctorId});

  @override
  Widget build(BuildContext context) {
    final role = context.watch<AuthCubit>().state.role;

    return BlocProvider(
      create: (context) => UserBookingBloc(
        doctorRepository: RepositoryProvider.of<DoctorRepository>(context),
        appointmentRepository: RepositoryProvider.of<AppointmentRepository>(context),
      )..add(UserBookingLoad(doctorId)),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_forward_rounded),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(AppStrings.bookingTitle),
        ),
        body: role != UserRole.patient
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.lock_outline_rounded, size: 64, color: AppColors.of(context).textLight),
                    const SizedBox(height: 16),
                    Text(AppStrings.bookingPatientOnly, style: TextStyle(color: AppColors.of(context).textSecondary)),
                  ],
                ),
              )
            : BlocConsumer<UserBookingBloc, UserBookingState>(
                listener: (context, state) {
                  if (state is UserBookingConfirmed) {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.appointmentConfirmation,
                      arguments: ConfirmationData(
                        appointmentId: state.appointmentId,
                        doctor: state.doctor,
                        date: state.date,
                        timeSlot: state.timeSlot,
                        patientName: state.patientName,
                      ),
                    );
                  }
                  if (state is UserBookingError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message), backgroundColor: Colors.red),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is UserBookingLoading || state is UserBookingInitial) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is UserBookingLoaded) {
                    final patientId = context.read<AuthCubit>().state.userId ?? 'p1';
                    final selectedSlot = state.selectedSlotId != null
                        ? state.slots.where((s) => s.id == state.selectedSlotId).firstOrNull
                        : null;

                    return Stack(
                      children: [
                        SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              DateSelectionBar(
                                dates: state.availableDates,
                                selectedDate: state.selectedDate,
                                onSelectDate: (date) {
                                  context.read<UserBookingBloc>().add(UserBookingSelectDate(date));
                                },
                              ),
                              const SizedBox(height: 24),
                              DoctorBookingCard(doctor: state.doctor),
                              const SizedBox(height: 24),
                              TimeSlotGrid(
                                slots: state.slots,
                                selectedSlotId: state.selectedSlotId,
                                onSelectSlot: (slotId) {
                                  context.read<UserBookingBloc>().add(UserBookingSelectSlot(slotId));
                                },
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: ConfirmBookingBar(
                            isEnabled: selectedSlot != null,
                            isLoading: state is UserBookingBooking,
                            onConfirm: () {
                              if (selectedSlot != null) {
                                context.read<UserBookingBloc>().add(UserBookingConfirm(
                                  patientId: patientId,
                                  patientName: context.read<AuthCubit>().state.userName ?? AppStrings.bookingDefaultPatientName,
                                  doctorId: doctorId,
                                  doctorEntity: state.doctor,
                                  date: state.selectedDate,
                                  timeSlot: selectedSlot.time,
                                ));
                              }
                            },
                          ),
                        ),
                      ],
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
      ),
    );
  }
}
