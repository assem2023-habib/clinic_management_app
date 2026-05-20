import 'package:clinic_management_app/domain/entities/patient_entity.dart';
import 'package:clinic_management_app/domain/repositories/patient_repository.dart';

class GetPatients {
  final PatientRepository repository;
  GetPatients(this.repository);

  Future<List<PatientEntity>> call() => repository.getAllPatients();
}
