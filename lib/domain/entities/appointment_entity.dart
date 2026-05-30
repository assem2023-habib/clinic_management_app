import 'package:equatable/equatable.dart';

enum AppointmentStatus {
  requested,
  set,
  accepted,
  rejected,
  cancelled,
  completed;

  static AppointmentStatus fromString(String s) {
    switch (s) {
      case 'requested': return AppointmentStatus.requested;
      case 'set': return AppointmentStatus.set;
      case 'accepted': return AppointmentStatus.accepted;
      case 'rejected': return AppointmentStatus.rejected;
      case 'cancelled': return AppointmentStatus.cancelled;
      case 'completed': return AppointmentStatus.completed;
      default: return AppointmentStatus.requested;
    }
  }
}

class AppointmentEntity extends Equatable {
  final String id;
  final AppointmentStatus status;
  final String? reason;
  final String? notes;
  final String? appointmentDate;
  final String? startTime;
  final String? endTime;
  final String? createdBy;
  final String? createdAt;
  final String? updatedAt;
  final Map<String, dynamic>? patient;
  final Map<String, dynamic>? doctor;

  const AppointmentEntity({
    required this.id,
    required this.status,
    this.reason,
    this.notes,
    this.appointmentDate,
    this.startTime,
    this.endTime,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.patient,
    this.doctor,
  });

  @override
  List<Object?> get props => [
    id, status, reason, notes, appointmentDate, startTime, endTime,
    createdBy, createdAt, updatedAt, patient, doctor,
  ];
}
