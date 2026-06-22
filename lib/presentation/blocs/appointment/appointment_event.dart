import 'package:equatable/equatable.dart';
import 'package:clinic_management_app/domain/entities/appointment_entity.dart';

abstract class AppointmentEvent extends Equatable {
  const AppointmentEvent();
  @override
  List<Object?> get props => [];
}

class AppointmentLoadAll extends AppointmentEvent {
  final int page;
  final int limit;
  const AppointmentLoadAll({this.page = 1, this.limit = 10});
  @override
  List<Object?> get props => [page, limit];
}

class AppointmentLoadMore extends AppointmentEvent {
  final int page;
  final int limit;
  const AppointmentLoadMore({this.page = 1, this.limit = 10});
  @override
  List<Object?> get props => [page, limit];
}

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

class AppointmentRequest extends AppointmentEvent {
  final String doctorId;
  final String? preferredDate;
  final String? reason;
  const AppointmentRequest(this.doctorId, {this.preferredDate, this.reason});
  @override
  List<Object?> get props => [doctorId, preferredDate, reason];
}

class AppointmentSetTime extends AppointmentEvent {
  final String appointmentId;
  final String date;
  final String startTime;
  final String endTime;
  const AppointmentSetTime(this.appointmentId, this.date, this.startTime, this.endTime);
  @override
  List<Object?> get props => [appointmentId, date, startTime, endTime];
}

class AppointmentRespond extends AppointmentEvent {
  final String appointmentId;
  final String response;
  const AppointmentRespond(this.appointmentId, this.response);
  @override
  List<Object?> get props => [appointmentId, response];
}

class AppointmentStart extends AppointmentEvent {
  final String appointmentId;
  const AppointmentStart(this.appointmentId);
  @override
  List<Object?> get props => [appointmentId];
}

class AppointmentCancel extends AppointmentEvent {
  final String appointmentId;
  const AppointmentCancel(this.appointmentId);
  @override
  List<Object?> get props => [appointmentId];
}

class AppointmentComplete extends AppointmentEvent {
  final String appointmentId;
  const AppointmentComplete(this.appointmentId);
  @override
  List<Object?> get props => [appointmentId];
}

class AppointmentSuggestAlternative extends AppointmentEvent {
  final String appointmentId;
  final String message;
  const AppointmentSuggestAlternative(this.appointmentId, this.message);
  @override
  List<Object?> get props => [appointmentId, message];
}

class AppointmentLoadBookedSlots extends AppointmentEvent {
  final String doctorId;
  final String? date;
  final String? fromDate;
  final String? toDate;
  const AppointmentLoadBookedSlots(this.doctorId, {this.date, this.fromDate, this.toDate});
  @override
  List<Object?> get props => [doctorId, date, fromDate, toDate];
}

class AppointmentWatchRtdb extends AppointmentEvent {
  final String doctorId;
  const AppointmentWatchRtdb(this.doctorId);
  @override
  List<Object?> get props => [doctorId];
}

class AppointmentStopRtdb extends AppointmentEvent {
  final String doctorId;
  const AppointmentStopRtdb(this.doctorId);
  @override
  List<Object?> get props => [doctorId];
}
