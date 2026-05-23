import 'package:clinic_management_app/domain/entities/time_slot_entity.dart';

class TimeSlotModel extends TimeSlotEntity {
  const TimeSlotModel({
    required super.id,
    required super.date,
    required super.time,
    super.isAvailable,
  });

  factory TimeSlotModel.fromMap(Map<String, dynamic> map) {
    return TimeSlotModel(
      id: map['id'] as String,
      date: DateTime.parse(map['date'] as String),
      time: map['time'] as String,
      isAvailable: map['isAvailable'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'date': date.toIso8601String(),
        'time': time,
        'isAvailable': isAvailable,
      };
}
