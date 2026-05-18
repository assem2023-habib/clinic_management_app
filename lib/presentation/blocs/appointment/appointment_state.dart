import 'package:equatable/equatable.dart';
import 'package:clinic_management_app/data/models/appointment.dart';

abstract class AppointmentState extends Equatable {
  const AppointmentState();
  @override
  List<Object?> get props => [];
}

class AppointmentInitial extends AppointmentState {}
class AppointmentLoading extends AppointmentState {}
class AppointmentLoaded extends AppointmentState {
  final List<Appointment> appointments;
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
