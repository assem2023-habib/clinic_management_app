import 'package:clinic_management_app/domain/entities/doctor_entity.dart';

abstract class DoctorRepository {
  Future<List<DoctorEntity>> getAllDoctors();
  Future<DoctorEntity?> getDoctorById(String id);
  Future<void> addDoctor(DoctorEntity doctor);
  Future<void> updateDoctor(DoctorEntity doctor);
  Future<void> deleteDoctor(String id);
  Future<List<DoctorEntity>> searchDoctors(String query);
}
