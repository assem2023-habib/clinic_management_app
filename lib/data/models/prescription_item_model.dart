import 'package:clinic_management_app/domain/entities/prescription_item_entity.dart';

class PrescriptionItemModel extends PrescriptionItemEntity {
  const PrescriptionItemModel({
    required super.id,
    super.prescriptionId,
    super.medicineId,
    required super.dosage,
    required super.frequency,
    required super.duration,
    super.instructions,
    super.createdAt,
    super.updatedAt,
  });

  factory PrescriptionItemModel.fromMap(Map<String, dynamic> map) {
    return PrescriptionItemModel(
      id: map['id'] as String,
      prescriptionId: map['prescription_id'] as String?,
      medicineId: map['medicine_id'] as String?,
      dosage: map['dosage'] as String? ?? '',
      frequency: map['frequency'] as String? ?? '',
      duration: map['duration'] as String? ?? '',
      instructions: map['instructions'] as String?,
      createdAt: map['created_at'] as String?,
      updatedAt: map['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'medicine_id': medicineId,
      'dosage': dosage,
      'frequency': frequency,
      'duration': duration,
      'instructions': instructions,
    };
  }
}
