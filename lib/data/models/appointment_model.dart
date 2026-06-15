import 'package:clinic_management_app/data/models/patient_model.dart';
import 'package:clinic_management_app/data/models/doctor_model.dart';
import 'package:clinic_management_app/domain/entities/appointment_entity.dart';

class AppointmentModel extends AppointmentEntity {
  const AppointmentModel({
    required super.id,
    required super.status,
    super.reason,
    super.notes,
    super.appointmentDate,
    super.startTime,
    super.endTime,
    super.createdBy,
    super.createdAt,
    super.updatedAt,
    super.patient,
    super.doctor,
    super.patientId,
    super.patientName,
    super.patientPhone,
    super.doctorId,
    super.doctorName,
    super.date,
    super.timeSlot,
  });

  factory AppointmentModel.fromMap(Map<String, dynamic> map) {
    PatientModel? patient;
    if (map['patient'] != null && map['patient'] is Map) {
      patient = PatientModel.fromMap(map['patient'] as Map<String, dynamic>);
    }
    DoctorModel? doctor;
    if (map['doctor'] != null && map['doctor'] is Map) {
      doctor = DoctorModel.fromMap(map['doctor'] as Map<String, dynamic>);
    }
    return AppointmentModel(
      id: map['id'] as String,
      status: AppointmentStatus.fromString(map['status'] as String? ?? 'requested'),
      reason: map['reason'] as String?,
      notes: map['notes'] as String?,
      appointmentDate: map['appointment_date'] as String?,
      startTime: map['start_time'] as String?,
      endTime: map['end_time'] as String?,
      createdBy: map['created_by'] as String?,
      createdAt: map['created_at'] as String?,
      updatedAt: map['updated_at'] as String?,
      patient: patient,
      doctor: doctor,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'status': status.toValue(),
      'reason': reason,
      'notes': notes,
      'appointment_date': appointmentDate,
      'start_time': startTime,
      'end_time': endTime,
      'created_by': createdBy,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  Map<String, dynamic> toCreateRequest() {
    return {
      'doctor_id': doctor?.id,
      'preferred_date': appointmentDate,
      'reason': reason,
    };
  }

  Map<String, dynamic> toSetTimeRequest() {
    return {
      'appointment_date': appointmentDate,
      'start_time': startTime,
      'end_time': endTime,
    };
  }

  Map<String, dynamic> toRespondRequest() {
    return {
      'response': status.toValue(),
    };
  }

  factory AppointmentModel.fromRtdbMap(Map<dynamic, dynamic> map) {
    final appointmentDate = map['appointment_date'] as String?;
    final startTime = map['start_time'] as String?;
    final endTime = map['end_time'] as String?;
    String? timeSlot;
    if (startTime != null && endTime != null) {
      timeSlot = '$startTime - $endTime';
    }
    return AppointmentModel(
      id: map['id'] as String? ?? '',
      status: AppointmentStatus.fromString(map['status'] as String? ?? 'requested'),
      reason: map['reason'] as String?,
      notes: map['notes'] as String?,
      appointmentDate: appointmentDate,
      startTime: startTime,
      endTime: endTime,
      createdAt: map['synced_at'] as String?,
      doctorId: map['doctor_id'] as String?,
      date: appointmentDate,
      timeSlot: timeSlot,
    );
  }

  Map<String, dynamic> toRtdbMap() {
    return {
      'id': id,
      'doctor_id': doctorId ?? doctor?.id,
      'patient_id': patientId ?? patient?.id,
      'patient_name': patientName ?? patient?.name,
      'patient_phone': patientPhone ?? patient?.phone,
      'appointment_date': appointmentDate,
      'start_time': startTime,
      'end_time': endTime,
      'status': status.toValue(),
      'reason': reason,
      'notes': notes,
      'synced_at': DateTime.now().toUtc().toIso8601String(),
      'synced_at_timestamp': DateTime.now().millisecondsSinceEpoch ~/ 1000,
    };
  }
}
