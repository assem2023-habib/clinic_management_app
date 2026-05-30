import 'package:equatable/equatable.dart';
import 'package:clinic_management_app/domain/entities/doctor_entity.dart';
import 'package:clinic_management_app/domain/entities/review_entity.dart';
import 'package:clinic_management_app/domain/entities/doctor_schedule_entity.dart';

class DoctorProfileEntity extends Equatable {
  final DoctorEntity doctor;
  final List<ReviewEntity> reviews;
  final List<DoctorScheduleEntity> availableSlots;

  const DoctorProfileEntity({
    required this.doctor,
    this.reviews = const [],
    this.availableSlots = const [],
  });

  @override
  List<Object?> get props => [doctor, reviews, availableSlots];
}
