import 'package:equatable/equatable.dart';

class TimeSlotEntity extends Equatable {
  final String id;
  final DateTime date;
  final String time;
  final bool isAvailable;

  const TimeSlotEntity({
    required this.id,
    required this.date,
    required this.time,
    this.isAvailable = true,
  });

  TimeSlotEntity copyWith({bool? isAvailable}) {
    return TimeSlotEntity(
      id: id,
      date: date,
      time: time,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }

  @override
  List<Object?> get props => [id, date, time, isAvailable];
}
