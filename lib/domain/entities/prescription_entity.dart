import 'package:equatable/equatable.dart';
import 'package:clinic_management_app/domain/entities/prescription_item_entity.dart';

class PrescriptionEntity extends Equatable {
  final String id;
  final String? medicalRecordId;
  final String? prescriptionDate;
  final String status;
  final String? notes;
  final List<PrescriptionItemEntity> items;
  final String? createdAt;
  final String? updatedAt;

  const PrescriptionEntity({
    required this.id,
    this.medicalRecordId,
    this.prescriptionDate,
    this.status = 'active',
    this.notes,
    this.items = const [],
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [id, medicalRecordId, prescriptionDate, status, notes, items, createdAt, updatedAt];
}
