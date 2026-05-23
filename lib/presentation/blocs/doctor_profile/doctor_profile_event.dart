import 'package:equatable/equatable.dart';
import 'package:clinic_management_app/domain/entities/review_entity.dart';

abstract class DoctorProfileEvent extends Equatable {
  const DoctorProfileEvent();
  @override
  List<Object?> get props => [];
}

class LoadDoctorProfile extends DoctorProfileEvent {
  final String doctorId;
  const LoadDoctorProfile(this.doctorId);
  @override
  List<Object?> get props => [doctorId];
}

class ToggleSlotAvailability extends DoctorProfileEvent {
  final String slotId;
  const ToggleSlotAvailability(this.slotId);
  @override
  List<Object?> get props => [slotId];
}

class SubmitReview extends DoctorProfileEvent {
  final String doctorId;
  final ReviewEntity review;
  const SubmitReview(this.doctorId, this.review);
  @override
  List<Object?> get props => [doctorId, review];
}
