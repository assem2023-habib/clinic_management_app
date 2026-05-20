import 'package:clinic_management_app/domain/entities/medical_record_entity.dart';

class MedicalRecordModel extends MedicalRecordEntity {
  const MedicalRecordModel({
    required super.id,
    required super.patientId,
    required super.patientName,
    required super.doctorId,
    required super.doctorName,
    required super.visitDate,
    required super.diagnosis,
    required super.prescription,
    super.notes,
  });

  factory MedicalRecordModel.fromMap(Map<String, dynamic> map) => MedicalRecordModel(
        id: map['id'] as String,
        patientId: map['patientId'] as String,
        patientName: map['patientName'] as String,
        doctorId: map['doctorId'] as String,
        doctorName: map['doctorName'] as String,
        visitDate: DateTime.parse(map['visitDate'] as String),
        diagnosis: map['diagnosis'] as String,
        prescription: map['prescription'] as String,
        notes: map['notes'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'patientId': patientId,
        'patientName': patientName,
        'doctorId': doctorId,
        'doctorName': doctorName,
        'visitDate': visitDate.toIso8601String(),
        'diagnosis': diagnosis,
        'prescription': prescription,
        'notes': notes,
      };
}
