import 'package:clinic_management_app/domain/entities/doctor_entity.dart';
import 'package:clinic_management_app/domain/repositories/doctor_repository.dart';

class UpdateDoctor {
  final DoctorRepository repository;
  UpdateDoctor(this.repository);

  Future<void> call(DoctorEntity doctor) => repository.updateDoctor(doctor);
}
