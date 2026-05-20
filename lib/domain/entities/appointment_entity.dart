enum AppointmentStatus { scheduled, completed, cancelled, inProgress }

class AppointmentEntity {
  final String id;
  final String patientId;
  final String patientName;
  final String doctorId;
  final String doctorName;
  final DateTime date;
  final String timeSlot;
  final AppointmentStatus status;
  final String? notes;

  const AppointmentEntity({
    required this.id,
    required this.patientId,
    required this.patientName,
    required this.doctorId,
    required this.doctorName,
    required this.date,
    required this.timeSlot,
    required this.status,
    this.notes,
  });
}
