import 'package:equatable/equatable.dart';

class SupervisionRequestEntity extends Equatable {
  final String id;
  final String patientId;
  final String doctorId;
  final String? patientName;
  final String? doctorName;
  final String status;
  final String? respondedAt;
  final String? createdAt;

  const SupervisionRequestEntity({
    required this.id,
    required this.patientId,
    required this.doctorId,
    this.patientName,
    this.doctorName,
    this.status = 'pending',
    this.respondedAt,
    this.createdAt,
  });

  @override
  List<Object?> get props => [id, patientId, doctorId, patientName, doctorName, status, respondedAt, createdAt];
}
