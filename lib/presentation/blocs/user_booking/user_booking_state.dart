import 'package:equatable/equatable.dart';
import 'package:clinic_management_app/domain/entities/doctor_entity.dart';
import 'package:clinic_management_app/domain/entities/time_slot_entity.dart';

abstract class UserBookingState extends Equatable {
  const UserBookingState();
  @override
  List<Object?> get props => [];
}

class UserBookingInitial extends UserBookingState {}

class UserBookingLoading extends UserBookingState {}

class UserBookingLoaded extends UserBookingState {
  final DoctorEntity doctor;
  final List<TimeSlotEntity> allSlots;
  final DateTime selectedDate;
  final String? selectedSlotId;
  final List<DateTime> availableDates;

  const UserBookingLoaded({
    required this.doctor,
    required this.allSlots,
    required this.selectedDate,
    this.selectedSlotId,
    this.availableDates = const [],
  });

  List<TimeSlotEntity> get slots => allSlots.where((s) =>
    s.date.year == selectedDate.year &&
    s.date.month == selectedDate.month &&
    s.date.day == selectedDate.day
  ).toList();

  UserBookingLoaded copyWith({
    DoctorEntity? doctor,
    List<TimeSlotEntity>? allSlots,
    DateTime? selectedDate,
    String? selectedSlotId,
    List<DateTime>? availableDates,
  }) {
    return UserBookingLoaded(
      doctor: doctor ?? this.doctor,
      allSlots: allSlots ?? this.allSlots,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedSlotId: selectedSlotId,
      availableDates: availableDates ?? this.availableDates,
    );
  }

  @override
  List<Object?> get props => [doctor, allSlots, selectedDate, selectedSlotId, availableDates];
}

class UserBookingBooking extends UserBookingState {}

class UserBookingConfirmed extends UserBookingState {
  final String appointmentId;
  final DoctorEntity doctor;
  final String patientName;
  final DateTime date;
  final String timeSlot;
  const UserBookingConfirmed({
    required this.appointmentId,
    required this.doctor,
    required this.patientName,
    required this.date,
    required this.timeSlot,
  });
  @override
  List<Object?> get props => [appointmentId, doctor, patientName, date, timeSlot];
}

class UserBookingError extends UserBookingState {
  final String message;
  const UserBookingError(this.message);
  @override
  List<Object?> get props => [message];
}
