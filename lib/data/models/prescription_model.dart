import 'package:clinic_management_app/data/models/prescription_item_model.dart';
import 'package:clinic_management_app/domain/entities/prescription_entity.dart';

class PrescriptionModel extends PrescriptionEntity {
  const PrescriptionModel({
    required super.id,
    super.medicalRecordId,
    super.prescriptionDate,
    super.status = 'active',
    super.notes,
    super.items = const [],
    super.createdAt,
    super.updatedAt,
  });

  factory PrescriptionModel.fromMap(Map<String, dynamic> map) {
    final itemsList = (map['items'] as List<dynamic>?)
            ?.map((e) => PrescriptionItemModel.fromMap(e as Map<String, dynamic>))
            .toList() ??
        [];
    return PrescriptionModel(
      id: map['id'] as String,
      medicalRecordId: map['medical_record_id'] as String?,
      prescriptionDate: map['prescription_date'] as String?,
      status: map['status'] as String? ?? 'active',
      notes: map['notes'] as String?,
      items: itemsList,
      createdAt: map['created_at'] as String?,
      updatedAt: map['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toCreateRequest() {
    return {
      if (prescriptionDate != null) 'prescription_date': prescriptionDate,
      'status': status,
      if (notes != null) 'notes': notes,
      'items': items.map((e) => (e as PrescriptionItemModel).toMap()).toList(),
    };
  }

  Map<String, dynamic> toUpdateRequest() {
    return {
      if (prescriptionDate != null) 'prescription_date': prescriptionDate,
      'status': status,
      if (notes != null) 'notes': notes,
    };
  }
}
