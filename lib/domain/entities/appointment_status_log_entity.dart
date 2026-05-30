import 'package:equatable/equatable.dart';
import 'package:clinic_management_app/domain/entities/appointment_entity.dart';

class AppointmentStatusLogEntity extends Equatable {
  final String appointmentId;
  final AppointmentStatus oldStatus;
  final AppointmentStatus newStatus;
  final String changedBy;
  final String createdAt;

  const AppointmentStatusLogEntity({
    required this.appointmentId,
    required this.oldStatus,
    required this.newStatus,
    required this.changedBy,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [appointmentId, oldStatus, newStatus, changedBy, createdAt];
}
