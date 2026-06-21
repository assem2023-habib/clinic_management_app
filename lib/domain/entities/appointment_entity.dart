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

  static const _sentinel = Object();

  AppointmentEntity copyWith({
    String? id,
    AppointmentStatus? status,
    Object? reason = _sentinel,
    Object? notes = _sentinel,
    Object? appointmentDate = _sentinel,
    Object? startTime = _sentinel,
    Object? endTime = _sentinel,
    Object? createdBy = _sentinel,
    Object? createdAt = _sentinel,
    Object? updatedAt = _sentinel,
    Object? patient = _sentinel,
    Object? doctor = _sentinel,
    Object? patientId = _sentinel,
    Object? patientName = _sentinel,
    Object? patientPhone = _sentinel,
    Object? doctorId = _sentinel,
    Object? doctorName = _sentinel,
    Object? date = _sentinel,
    Object? timeSlot = _sentinel,
  }) {
    return AppointmentEntity(
      id: id ?? this.id,
      status: status ?? this.status,
      reason: reason == _sentinel ? this.reason : reason as String?,
      notes: notes == _sentinel ? this.notes : notes as String?,
      appointmentDate: appointmentDate == _sentinel ? this.appointmentDate : appointmentDate as String?,
      startTime: startTime == _sentinel ? this.startTime : startTime as String?,
      endTime: endTime == _sentinel ? this.endTime : endTime as String?,
      createdBy: createdBy == _sentinel ? this.createdBy : createdBy as String?,
      createdAt: createdAt == _sentinel ? this.createdAt : createdAt as String?,
      updatedAt: updatedAt == _sentinel ? this.updatedAt : updatedAt as String?,
      patient: patient == _sentinel ? this.patient : patient as PatientEntity?,
      doctor: doctor == _sentinel ? this.doctor : doctor as DoctorEntity?,
      patientId: patientId == _sentinel ? this.patientId : patientId as String?,
      patientName: patientName == _sentinel ? this.patientName : patientName as String?,
      patientPhone: patientPhone == _sentinel ? this.patientPhone : patientPhone as String?,
      doctorId: doctorId == _sentinel ? this.doctorId : doctorId as String?,
      doctorName: doctorName == _sentinel ? this.doctorName : doctorName as String?,
      date: date == _sentinel ? this.date : date as String?,
      timeSlot: timeSlot == _sentinel ? this.timeSlot : timeSlot as String?,
    );
  }

  @override
  List<Object?> get props => [
    id, status, reason, notes, appointmentDate, startTime, endTime,
    createdBy, createdAt, updatedAt, patient, doctor,
    patientId, patientName, patientPhone,
    doctorId, doctorName, date, timeSlot,
  ];
}
