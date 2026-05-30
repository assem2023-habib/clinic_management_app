import 'package:equatable/equatable.dart';

class PrescriptionItemEntity extends Equatable {
  final String id;
  final String? prescriptionId;
  final String? medicineId;
  final String dosage;
  final String frequency;
  final String duration;
  final String? instructions;
  final String? createdAt;
  final String? updatedAt;

  const PrescriptionItemEntity({
    required this.id,
    this.prescriptionId,
    this.medicineId,
    required this.dosage,
    required this.frequency,
    required this.duration,
    this.instructions,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [id, prescriptionId, medicineId, dosage, frequency, duration, instructions, createdAt, updatedAt];
}
