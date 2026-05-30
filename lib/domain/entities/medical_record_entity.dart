import 'package:equatable/equatable.dart';

class MedicalRecordEntity extends Equatable {
  final String id;
  final String patientId;
  final String? doctorId;
  final String diagnosis;
  final String? notes;
  final String? createdAt;
  final String? patientName;
  final String? doctorName;
  final String? prescription;
  final String? visitDate;

  const MedicalRecordEntity({
    required this.id,
    required this.patientId,
    this.doctorId,
    required this.diagnosis,
    this.notes,
    this.createdAt,
    this.patientName,
    this.doctorName,
    this.prescription,
    this.visitDate,
  });

  @override
  List<Object?> get props => [
    id, patientId, doctorId, diagnosis, notes, createdAt,
    patientName, doctorName, prescription, visitDate,
  ];
}
