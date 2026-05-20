import 'package:clinic_management_app/domain/entities/patient_entity.dart';
import 'package:clinic_management_app/domain/repositories/patient_repository.dart';

class SearchPatients {
  final PatientRepository repository;
  SearchPatients(this.repository);

  Future<List<PatientEntity>> call(String query) => repository.searchPatients(query);
}
