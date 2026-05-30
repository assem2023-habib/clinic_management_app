import 'package:clinic_management_app/domain/entities/medical_record_entity.dart';

class MedicalRecordModel extends MedicalRecordEntity {
  const MedicalRecordModel({
    required super.id,
    required super.patientId,
    super.doctorId,
    required super.diagnosis,
    super.notes,
    super.createdAt,
  });

  factory MedicalRecordModel.fromMap(Map<String, dynamic> map) {
    return MedicalRecordModel(
      id: map['id'] as String,
      patientId: map['patient_id'] as String? ?? '',
      doctorId: map['doctor_id'] as String?,
      diagnosis: map['diagnosis'] as String? ?? '',
      notes: map['notes'] as String?,
      createdAt: map['created_at'] as String?,
    );
  }
}
