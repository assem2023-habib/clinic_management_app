import 'package:equatable/equatable.dart';

class MedicalRecordEntity extends Equatable {
  final String id;
  final String patientId;
  final String? doctorId;
  final String diagnosis;
  final String? notes;
  final String? createdAt;

  const MedicalRecordEntity({
    required this.id,
    required this.patientId,
    this.doctorId,
    required this.diagnosis,
    this.notes,
    this.createdAt,
  });

  @override
  List<Object?> get props => [id, patientId, doctorId, diagnosis, notes, createdAt];
}
