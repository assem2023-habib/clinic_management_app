import 'package:clinic_management_app/domain/entities/supervision_entity.dart';

class SupervisionModel extends SupervisionEntity {
  const SupervisionModel({
    required super.doctorId,
    required super.patientId,
    super.doctorName,
    super.patientName,
    super.assignedBy,
    super.notes,
    super.status = 'active',
    super.supervisionStart,
    super.supervisionEnd,
    super.createdAt,
  });

  factory SupervisionModel.fromMap(Map<String, dynamic> map) {
    final doctor = map['doctor'] as Map<String, dynamic>?;
    final patient = map['patient'] as Map<String, dynamic>?;
    return SupervisionModel(
      doctorId: doctor?['id'] as String? ?? map['doctor_id'] as String,
      patientId: patient?['id'] as String? ?? map['patient_id'] as String,
      doctorName: doctor != null ? '${doctor['first_name']} ${doctor['last_name']}' : map['doctor_name'] as String?,
      patientName: patient != null ? '${patient['first_name']} ${patient['last_name']}' : map['patient_name'] as String?,
      assignedBy: map['assigned_by'] as String?,
      notes: map['notes'] as String?,
      status: map['supervision_status'] as String? ?? 'active',
      supervisionStart: map['supervision_start'] as String?,
      supervisionEnd: map['supervision_end'] as String?,
      createdAt: map['created_at'] as String?,
    );
  }
}
