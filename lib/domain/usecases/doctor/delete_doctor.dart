import 'package:clinic_management_app/domain/repositories/doctor_repository.dart';

class DeleteDoctor {
  final DoctorRepository repository;
  DeleteDoctor(this.repository);

  Future<void> call(String id) => repository.deleteDoctor(id);
}
