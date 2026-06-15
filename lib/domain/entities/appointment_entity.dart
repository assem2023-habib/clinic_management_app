import 'package:equatable/equatable.dart';
import 'package:clinic_management_app/domain/entities/patient_entity.dart';
import 'package:clinic_management_app/domain/entities/doctor_entity.dart';

enum AppointmentStatus {
  pending,
  requested,
  set,
  scheduled,
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
      case 'scheduled': return AppointmentStatus.scheduled;
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
  final String? patientId;
  final String? patientName;
  final String? patientPhone;
  final String? doctorId;
  final String? doctorName;
  final String? date;
  final String? timeSlot;

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
    this.patientId,
    this.patientName,
    this.patientPhone,
    this.doctorId,
    this.doctorName,
    this.date,
    this.timeSlot,
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
    String? patientId,
    String? patientName,
    String? patientPhone,
    String? doctorId,
    String? doctorName,
    String? date,
    String? timeSlot,
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
      patientId: patientId ?? this.patientId,
      patientName: patientName ?? this.patientName,
      patientPhone: patientPhone ?? this.patientPhone,
      doctorId: doctorId ?? this.doctorId,
      doctorName: doctorName ?? this.doctorName,
      date: date ?? this.date,
      timeSlot: timeSlot ?? this.timeSlot,
    );
  }

  @override
  List<Object?> get props => [
    id, status, reason, notes, appointmentDate, startTime, endTime,
    createdBy, createdAt, updatedAt, patient, doctor, patientPhone,
  ];
}
