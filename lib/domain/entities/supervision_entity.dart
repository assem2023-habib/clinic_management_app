import 'package:equatable/equatable.dart';

class SupervisionEntity extends Equatable {
  final String doctorId;
  final String patientId;
  final String? doctorName;
  final String? patientName;
  final String? assignedBy;
  final String? notes;
  final String status;
  final String? supervisionStart;
  final String? supervisionEnd;
  final String? createdAt;

  const SupervisionEntity({
    required this.doctorId,
    required this.patientId,
    this.doctorName,
    this.patientName,
    this.assignedBy,
    this.notes,
    this.status = 'active',
    this.supervisionStart,
    this.supervisionEnd,
    this.createdAt,
  });

  @override
  List<Object?> get props => [doctorId, patientId, doctorName, patientName, assignedBy, notes, status, supervisionStart, supervisionEnd, createdAt];
}
