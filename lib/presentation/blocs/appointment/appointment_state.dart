import 'package:equatable/equatable.dart';
import 'package:clinic_management_app/domain/entities/appointment_entity.dart';
import 'package:clinic_management_app/domain/entities/booked_slot_entity.dart';

abstract class AppointmentState extends Equatable {
  const AppointmentState();
  @override
  List<Object?> get props => [];
}

class AppointmentInitial extends AppointmentState {}
class AppointmentLoading extends AppointmentState {}
class AppointmentLoaded extends AppointmentState {
  final List<AppointmentEntity> appointments;
  const AppointmentLoaded(this.appointments);
  @override
  List<Object?> get props => [appointments];
}
class AppointmentError extends AppointmentState {
  final String message;
  const AppointmentError(this.message);
  @override
  List<Object?> get props => [message];
}

class AppointmentWorkflowSuccess extends AppointmentState {
  final AppointmentEntity appointment;
  final String message;
  const AppointmentWorkflowSuccess(this.appointment, {this.message = ''});
  @override
  List<Object?> get props => [appointment, message];
}

class BookedSlotsLoading extends AppointmentState {}
class BookedSlotsLoaded extends AppointmentState {
  final List<BookedSlotEntity> slots;
  const BookedSlotsLoaded(this.slots);
  @override
  List<Object?> get props => [slots];
}
