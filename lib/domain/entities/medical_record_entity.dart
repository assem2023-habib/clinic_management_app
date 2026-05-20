class MedicalRecordEntity {
  final String id;
  final String patientId;
  final String patientName;
  final String doctorId;
  final String doctorName;
  final DateTime visitDate;
  final String diagnosis;
  final String prescription;
  final String? notes;

  const MedicalRecordEntity({
    required this.id,
    required this.patientId,
    required this.patientName,
    required this.doctorId,
    required this.doctorName,
    required this.visitDate,
    required this.diagnosis,
    required this.prescription,
    this.notes,
  });
}
