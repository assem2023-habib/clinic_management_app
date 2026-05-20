import 'package:clinic_management_app/domain/entities/doctor_entity.dart';
import 'package:clinic_management_app/domain/repositories/doctor_repository.dart';

class GetDoctors {
  final DoctorRepository repository;
  GetDoctors(this.repository);

  Future<List<DoctorEntity>> call() => repository.getAllDoctors();
}
