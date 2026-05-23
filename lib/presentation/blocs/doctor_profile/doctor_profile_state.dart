import 'package:equatable/equatable.dart';
import 'package:clinic_management_app/domain/entities/doctor_profile_entity.dart';

abstract class DoctorProfileState extends Equatable {
  const DoctorProfileState();
  @override
  List<Object?> get props => [];
}

class DoctorProfileInitial extends DoctorProfileState {}

class DoctorProfileLoading extends DoctorProfileState {}

class DoctorProfileLoaded extends DoctorProfileState {
  final DoctorProfileEntity profile;
  const DoctorProfileLoaded(this.profile);
  @override
  List<Object?> get props => [profile];
}

class DoctorProfileError extends DoctorProfileState {
  final String message;
  const DoctorProfileError(this.message);
  @override
  List<Object?> get props => [message];
}
