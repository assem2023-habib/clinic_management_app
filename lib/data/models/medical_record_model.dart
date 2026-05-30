import 'package:clinic_management_app/domain/entities/medical_record_entity.dart';

class MedicalRecordModel extends MedicalRecordEntity {
  const MedicalRecordModel({
    required super.id,
    required super.patientId,
    super.doctorId,
    required super.diagnosis,
    super.notes,
    super.createdAt,
    super.patientName,
    super.doctorName,
    super.prescription,
    super.visitDate,
  });

  factory MedicalRecordModel.fromMap(Map<String, dynamic> map) {
    return MedicalRecordModel(
      id: map['id'] as String,
      patientId: map['patient_id'] as String? ?? '',
      doctorId: map['doctor_id'] as String?,
      diagnosis: map['diagnosis'] as String? ?? '',
      notes: map['notes'] as String?,
      createdAt: map['created_at'] as String?,
      patientName: map['patient_name'] as String?,
      doctorName: map['doctor_name'] as String?,
      prescription: map['prescription'] as String?,
      visitDate: map['visit_date'] as String?,
    );
  }
}
