import 'package:equatable/equatable.dart';
import 'package:clinic_management_app/domain/entities/doctor_entity.dart';

abstract class DoctorEvent extends Equatable {
  const DoctorEvent();
  @override
  List<Object?> get props => [];
}

class DoctorLoadAll extends DoctorEvent {
  final String? specializationId;
  const DoctorLoadAll({this.specializationId});
  @override
  List<Object?> get props => [specializationId];
}
class DoctorSearch extends DoctorEvent {
  final String query;
  const DoctorSearch(this.query);
  @override
  List<Object?> get props => [query];
}
class DoctorAdd extends DoctorEvent {
  final DoctorEntity doctor;
  const DoctorAdd(this.doctor);
  @override
  List<Object?> get props => [doctor];
}
class DoctorUpdate extends DoctorEvent {
  final DoctorEntity doctor;
  const DoctorUpdate(this.doctor);
  @override
  List<Object?> get props => [doctor];
}
class DoctorDelete extends DoctorEvent {
  final String id;
  const DoctorDelete(this.id);
  @override
  List<Object?> get props => [id];
}
class DoctorLoadPatientAppointments extends DoctorEvent {
  final String patientId;
  const DoctorLoadPatientAppointments(this.patientId);
  @override
  List<Object?> get props => [patientId];
}
