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
  });

  factory AppointmentModel.fromMap(Map<String, dynamic> map) {
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
      patient: map['patient'] as Map<String, dynamic>?,
      doctor: map['doctor'] as Map<String, dynamic>?,
    );
  }
}
