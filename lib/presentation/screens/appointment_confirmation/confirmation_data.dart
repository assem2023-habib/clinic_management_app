import 'package:clinic_management_app/domain/entities/doctor_entity.dart';

class ConfirmationData {
  final String appointmentId;
  final DoctorEntity doctor;
  final DateTime date;
  final String timeSlot;
  final String patientName;
  final String? notes;

  const ConfirmationData({
    required this.appointmentId,
    required this.doctor,
    required this.date,
    required this.timeSlot,
    required this.patientName,
    this.notes,
  });
}
