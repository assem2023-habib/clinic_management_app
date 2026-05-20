import 'package:clinic_management_app/domain/entities/patient_entity.dart';
import 'package:clinic_management_app/domain/repositories/patient_repository.dart';

class UpdatePatient {
  final PatientRepository repository;
  UpdatePatient(this.repository);

  Future<void> call(PatientEntity patient) => repository.updatePatient(patient);
}
