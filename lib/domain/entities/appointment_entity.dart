import 'package:equatable/equatable.dart';

enum AppointmentStatus { scheduled, completed, cancelled, inProgress }

class AppointmentEntity extends Equatable {
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

  AppointmentEntity copyWith({
    String? id,
    String? patientId,
    String? patientName,
    String? doctorId,
    String? doctorName,
    DateTime? date,
    String? timeSlot,
    AppointmentStatus? status,
    String? notes,
  }) {
    return AppointmentEntity(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      patientName: patientName ?? this.patientName,
      doctorId: doctorId ?? this.doctorId,
      doctorName: doctorName ?? this.doctorName,
      date: date ?? this.date,
      timeSlot: timeSlot ?? this.timeSlot,
      status: status ?? this.status,
      notes: notes ?? this.notes,
    );
  }

  @override
  List<Object?> get props => [id, patientId, patientName, doctorId, doctorName, date, timeSlot, status, notes];
}
