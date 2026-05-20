import 'package:clinic_management_app/domain/entities/doctor_entity.dart';
import 'package:clinic_management_app/domain/repositories/doctor_repository.dart';

class SearchDoctors {
  final DoctorRepository repository;
  SearchDoctors(this.repository);

  Future<List<DoctorEntity>> call(String query) => repository.searchDoctors(query);
}
