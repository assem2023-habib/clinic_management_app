import 'package:equatable/equatable.dart';

class DoctorScheduleEntity extends Equatable {
  final String id;
  final String dayOfWeek;
  final String startTime;
  final String endTime;
  final bool isActive;

  const DoctorScheduleEntity({
    required this.id,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    this.isActive = true,
  });

  @override
  List<Object?> get props => [id, dayOfWeek, startTime, endTime, isActive];
}
