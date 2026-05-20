import 'package:clinic_management_app/domain/entities/appointment_entity.dart';

class AppointmentModel extends AppointmentEntity {
  const AppointmentModel({
    required super.id,
    required super.patientId,
    required super.patientName,
    required super.doctorId,
    required super.doctorName,
    required super.date,
    required super.timeSlot,
    required super.status,
    super.notes,
  });

  factory AppointmentModel.fromMap(Map<String, dynamic> map) => AppointmentModel(
        id: map['id'] as String,
        patientId: map['patientId'] as String,
        patientName: map['patientName'] as String,
        doctorId: map['doctorId'] as String,
        doctorName: map['doctorName'] as String,
        date: DateTime.parse(map['date'] as String),
        timeSlot: map['timeSlot'] as String,
        status: _parseStatus(map['status'] as String),
        notes: map['notes'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'patientId': patientId,
        'patientName': patientName,
        'doctorId': doctorId,
        'doctorName': doctorName,
        'date': date.toIso8601String(),
        'timeSlot': timeSlot,
        'status': status.name,
        'notes': notes,
      };

  static AppointmentStatus _parseStatus(String s) {
    switch (s) {
      case 'scheduled': return AppointmentStatus.scheduled;
      case 'completed': return AppointmentStatus.completed;
      case 'cancelled': return AppointmentStatus.cancelled;
      case 'inProgress': return AppointmentStatus.inProgress;
      default: return AppointmentStatus.scheduled;
    }
  }
}
