import 'package:equatable/equatable.dart';

class MedicalRecord extends Equatable {
  final String id;
  final String patientId;
  final String patientName;
  final String doctorId;
  final String doctorName;
  final DateTime visitDate;
  final String diagnosis;
  final String prescription;
  final String? notes;

  const MedicalRecord({
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

  MedicalRecord copyWith({
    String? id,
    String? patientId,
    String? patientName,
    String? doctorId,
    String? doctorName,
    DateTime? visitDate,
    String? diagnosis,
    String? prescription,
    String? notes,
  }) {
    return MedicalRecord(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      patientName: patientName ?? this.patientName,
      doctorId: doctorId ?? this.doctorId,
      doctorName: doctorName ?? this.doctorName,
      visitDate: visitDate ?? this.visitDate,
      diagnosis: diagnosis ?? this.diagnosis,
      prescription: prescription ?? this.prescription,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toMap() {
    return {
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

  factory MedicalRecord.fromMap(Map<String, dynamic> map) {
    return MedicalRecord(
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
  }

  @override
  List<Object?> get props => [id, patientId, patientName, doctorId, doctorName, visitDate, diagnosis, prescription, notes];
}
