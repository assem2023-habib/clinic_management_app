import 'package:clinic_management_app/data/datasources/local/mock_datasource.dart';
import 'package:clinic_management_app/data/models/doctor_model.dart';
import 'package:clinic_management_app/domain/entities/doctor_entity.dart';
import 'package:clinic_management_app/domain/repositories/doctor_repository.dart';

class DoctorRepositoryImpl implements DoctorRepository {
  final MockDataSource dataSource;

  DoctorRepositoryImpl(this.dataSource);

  @override
  Future<List<DoctorEntity>> getAllDoctors() async => dataSource.allDoctors;

  @override
  Future<DoctorEntity?> getDoctorById(String id) async => dataSource.doctorById(id);

  @override
  Future<void> addDoctor(DoctorEntity doctor) async {
    dataSource.addDoctor(DoctorModel(
      id: doctor.id, name: doctor.name, specialty: doctor.specialty,
      phone: doctor.phone, email: doctor.email,
      imageUrl: doctor.imageUrl, isAvailable: doctor.isAvailable,
    ));
  }

  @override
  Future<void> updateDoctor(DoctorEntity doctor) async {
    dataSource.updateDoctor(DoctorModel(
      id: doctor.id, name: doctor.name, specialty: doctor.specialty,
      phone: doctor.phone, email: doctor.email,
      imageUrl: doctor.imageUrl, isAvailable: doctor.isAvailable,
    ));
  }

  @override
  Future<void> deleteDoctor(String id) async => dataSource.deleteDoctor(id);

  @override
  Future<List<DoctorEntity>> searchDoctors(String query) async => dataSource.searchDoctors(query);
}
