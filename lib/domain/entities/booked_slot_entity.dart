import 'package:equatable/equatable.dart';

class BookedSlotEntity extends Equatable {
  final String appointmentDate;
  final String startTime;
  final String endTime;

  const BookedSlotEntity({
    required this.appointmentDate,
    required this.startTime,
    required this.endTime,
  });

  @override
  List<Object?> get props => [appointmentDate, startTime, endTime];
}
