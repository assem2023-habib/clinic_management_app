import 'package:equatable/equatable.dart';
import 'package:clinic_management_app/data/models/patient.dart';

abstract class PatientEvent extends Equatable {
  const PatientEvent();
  @override
  List<Object?> get props => [];
}

class PatientLoadAll extends PatientEvent {}
class PatientSearch extends PatientEvent {
  final String query;
  const PatientSearch(this.query);
  @override
  List<Object?> get props => [query];
}
class PatientAdd extends PatientEvent {
  final Patient patient;
  const PatientAdd(this.patient);
  @override
  List<Object?> get props => [patient];
}
class PatientUpdate extends PatientEvent {
  final Patient patient;
  const PatientUpdate(this.patient);
  @override
  List<Object?> get props => [patient];
}
class PatientDelete extends PatientEvent {
  final String id;
  const PatientDelete(this.id);
  @override
  List<Object?> get props => [id];
}
