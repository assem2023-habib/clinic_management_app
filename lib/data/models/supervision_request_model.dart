import 'package:clinic_management_app/domain/entities/supervision_request_entity.dart';

class SupervisionRequestModel extends SupervisionRequestEntity {
  const SupervisionRequestModel({
    required super.id,
    required super.patientId,
    required super.doctorId,
    super.patientName,
    super.doctorName,
    super.status = 'pending',
    super.respondedAt,
    super.createdAt,
  });

  factory SupervisionRequestModel.fromMap(Map<String, dynamic> map) {
    final patient = map['patient'] as Map<String, dynamic>?;
    final doctor = map['doctor'] as Map<String, dynamic>?;
    return SupervisionRequestModel(
      id: map['id'] as String,
      patientId: map['patient_id'] as String? ?? (patient?['id'] as String? ?? ''),
      doctorId: map['doctor_id'] as String? ?? (doctor?['id'] as String? ?? ''),
      patientName: patient != null ? '${patient['first_name']} ${patient['last_name']}' : map['patient_name'] as String?,
      doctorName: doctor != null ? '${doctor['first_name']} ${doctor['last_name']}' : map['doctor_name'] as String?,
      status: map['status'] as String? ?? 'pending',
      respondedAt: map['responded_at'] as String?,
      createdAt: map['created_at'] as String?,
    );
  }

  Map<String, dynamic> toCreateRequest() {
    return {'doctor_id': doctorId};
  }
}
