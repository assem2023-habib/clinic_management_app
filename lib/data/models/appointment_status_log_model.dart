import 'package:clinic_management_app/domain/entities/appointment_entity.dart';
import 'package:clinic_management_app/domain/entities/appointment_status_log_entity.dart';

class AppointmentStatusLogModel extends AppointmentStatusLogEntity {
  const AppointmentStatusLogModel({
    required super.appointmentId,
    required super.oldStatus,
    required super.newStatus,
    required super.changedBy,
    required super.createdAt,
  });

  factory AppointmentStatusLogModel.fromMap(Map<String, dynamic> map) {
    return AppointmentStatusLogModel(
      appointmentId: map['appointment_id'] as String,
      oldStatus: AppointmentStatus.fromString(map['old_status'] as String? ?? ''),
      newStatus: AppointmentStatus.fromString(map['new_status'] as String? ?? ''),
      changedBy: map['changed_by'] as String? ?? '',
      createdAt: map['created_at'] as String? ?? '',
    );
  }
}
