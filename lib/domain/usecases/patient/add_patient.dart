import 'package:clinic_management_app/domain/entities/patient_entity.dart';
import 'package:clinic_management_app/domain/repositories/patient_repository.dart';

class AddPatient {
  final PatientRepository repository;
  AddPatient(this.repository);

  Future<void> call(PatientEntity patient) => repository.addPatient(patient);
}
