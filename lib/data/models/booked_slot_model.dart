import 'package:clinic_management_app/domain/entities/booked_slot_entity.dart';

class BookedSlotModel extends BookedSlotEntity {
  const BookedSlotModel({
    required super.appointmentDate,
    required super.startTime,
    required super.endTime,
  });

  factory BookedSlotModel.fromMap(Map<String, dynamic> map) {
    return BookedSlotModel(
      appointmentDate: map['appointment_date'] as String? ?? '',
      startTime: map['start_time'] as String? ?? '',
      endTime: map['end_time'] as String? ?? '',
    );
  }
}
