import 'package:clinic_management_app/domain/entities/doctor_schedule_entity.dart';

class DoctorScheduleModel extends DoctorScheduleEntity {
  const DoctorScheduleModel({
    required super.id,
    required super.dayOfWeek,
    required super.startTime,
    required super.endTime,
    super.isActive = true,
  });

  factory DoctorScheduleModel.fromMap(Map<String, dynamic> map) {
    return DoctorScheduleModel(
      id: map['id'] as String,
      dayOfWeek: map['day_of_week'] as String? ?? '',
      startTime: map['start_time'] as String? ?? '',
      endTime: map['end_time'] as String? ?? '',
      isActive: map['is_active'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'day_of_week': dayOfWeek,
    'start_time': startTime,
    'end_time': endTime,
    'is_active': isActive,
  };
}
