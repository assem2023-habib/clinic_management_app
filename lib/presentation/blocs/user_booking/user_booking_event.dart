import 'package:equatable/equatable.dart';
import 'package:clinic_management_app/domain/entities/doctor_entity.dart';

abstract class UserBookingEvent extends Equatable {
  const UserBookingEvent();
  @override
  List<Object?> get props => [];
}

class UserBookingLoad extends UserBookingEvent {
  final String doctorId;
  const UserBookingLoad(this.doctorId);
  @override
  List<Object?> get props => [doctorId];
}

class UserBookingSelectDate extends UserBookingEvent {
  final DateTime date;
  const UserBookingSelectDate(this.date);
  @override
  List<Object?> get props => [date];
}

class UserBookingSelectSlot extends UserBookingEvent {
  final String slotId;
  const UserBookingSelectSlot(this.slotId);
  @override
  List<Object?> get props => [slotId];
}

class UserBookingConfirm extends UserBookingEvent {
  final String patientId;
  final String patientName;
  final String doctorId;
  final DoctorEntity doctorEntity;
  final DateTime date;
  final String timeSlot;
  final String? notes;
  const UserBookingConfirm({
    required this.patientId,
    required this.patientName,
    required this.doctorId,
    required this.doctorEntity,
    required this.date,
    required this.timeSlot,
    this.notes,
  });
  @override
  List<Object?> get props => [patientId, patientName, doctorId, doctorEntity, date, timeSlot, notes];
}
