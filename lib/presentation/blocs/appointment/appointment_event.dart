import 'package:equatable/equatable.dart';
import 'package:clinic_management_app/domain/entities/appointment_entity.dart';

abstract class AppointmentEvent extends Equatable {
  const AppointmentEvent();
  @override
  List<Object?> get props => [];
}

class AppointmentLoadAll extends AppointmentEvent {}

class AppointmentLoadByDate extends AppointmentEvent {
  final DateTime date;
  const AppointmentLoadByDate(this.date);
  @override
  List<Object?> get props => [date];
}

class AppointmentAdd extends AppointmentEvent {
  final AppointmentEntity appointment;
  const AppointmentAdd(this.appointment);
  @override
  List<Object?> get props => [appointment];
}

class AppointmentUpdate extends AppointmentEvent {
  final AppointmentEntity appointment;
  const AppointmentUpdate(this.appointment);
  @override
  List<Object?> get props => [appointment];
}

class AppointmentDelete extends AppointmentEvent {
  final String id;
  const AppointmentDelete(this.id);
  @override
  List<Object?> get props => [id];
}

class AppointmentUpdateStatus extends AppointmentEvent {
  final String id;
  final AppointmentStatus status;
  const AppointmentUpdateStatus(this.id, this.status);
  @override
  List<Object?> get props => [id, status];
}
