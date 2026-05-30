import 'package:equatable/equatable.dart';
import 'package:clinic_management_app/domain/entities/patient_entity.dart';
import 'package:clinic_management_app/domain/entities/doctor_entity.dart';

enum AppointmentStatus {
  pending,
  requested,
  set,
  accepted,
  rejected,
  inProgress,
  confirmed,
  cancelled,
  completed;

  String toValue() {
    if (this == AppointmentStatus.inProgress) return 'in_progress';
    return name;
  }

  static AppointmentStatus fromString(String s) {
    switch (s) {
      case 'pending': return AppointmentStatus.pending;
      case 'requested': return AppointmentStatus.requested;
      case 'set': return AppointmentStatus.set;
      case 'accepted': return AppointmentStatus.accepted;
      case 'rejected': return AppointmentStatus.rejected;
      case 'in_progress': return AppointmentStatus.inProgress;
      case 'confirmed': return AppointmentStatus.confirmed;
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
  final PatientEntity? patient;
  final DoctorEntity? doctor;

  String? get patientName {
    if (patient == null) return null;
    return '${patient!.firstName} ${patient!.lastName}';
  }

  String? get doctorName {
    if (doctor == null) return null;
    return '${doctor!.firstName} ${doctor!.lastName}';
  }

  String? get date => appointmentDate;

  String? get timeSlot {
    if (startTime == null && endTime == null) return null;
    if (startTime != null && endTime != null) return '$startTime - $endTime';
    return startTime ?? endTime;
  }

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

  AppointmentEntity copyWith({
    String? id,
    AppointmentStatus? status,
    String? reason,
    String? notes,
    String? appointmentDate,
    String? startTime,
    String? endTime,
    String? createdBy,
    String? createdAt,
    String? updatedAt,
    PatientEntity? patient,
    DoctorEntity? doctor,
  }) {
    return AppointmentEntity(
      id: id ?? this.id,
      status: status ?? this.status,
      reason: reason ?? this.reason,
      notes: notes ?? this.notes,
      appointmentDate: appointmentDate ?? this.appointmentDate,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      patient: patient ?? this.patient,
      doctor: doctor ?? this.doctor,
    );
  }

  @override
  List<Object?> get props => [
    id, status, reason, notes, appointmentDate, startTime, endTime,
    createdBy, createdAt, updatedAt, patient, doctor,
  ];
}
