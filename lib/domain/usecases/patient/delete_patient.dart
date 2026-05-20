import 'package:clinic_management_app/domain/repositories/patient_repository.dart';

class DeletePatient {
  final PatientRepository repository;
  DeletePatient(this.repository);

  Future<void> call(String id) => repository.deletePatient(id);
}
