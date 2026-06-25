import 'package:clinic_management_app/data/datasources/patient_data_source.dart';
import 'package:clinic_management_app/data/datasources/remote/patient_remote_datasource.dart';
import 'package:clinic_management_app/data/models/patient_model.dart';
import 'package:clinic_management_app/domain/entities/patient_entity.dart';
import 'package:clinic_management_app/domain/repositories/patient_repository.dart';

class PatientRepositoryImpl implements PatientRepository {
  final PatientDataSource dataSource;
  final PatientRemoteDataSource? remoteDataSource;

  PatientRepositoryImpl(this.dataSource, {this.remoteDataSource});

  @override
  Future<List<PatientEntity>> getAllPatients({String? query, String? gender, bool? isActive, int page = 1, int limit = 20}) async {
    if (remoteDataSource != null) {
      try {
        return await remoteDataSource!.getPatients(search: query, gender: gender, isActive: isActive, page: page, limit: limit);
      } catch (_) {}
    }
    if (query != null && query.isNotEmpty) {
      return dataSource.searchPatients(query);
    }
    return dataSource.allPatients;
  }

  @override
  Future<PatientEntity?> getPatientById(String id) async {
    if (remoteDataSource != null) {
      try {
        return await remoteDataSource!.getPatientById(id);
      } catch (_) {}
    }
    return dataSource.patientById(id);
  }

  @override
  Future<void> addPatient(PatientEntity patient) async {
    await createPatient(patient);
  }

  @override
  Future<PatientEntity> createPatient(PatientEntity patient) async {
    if (remoteDataSource != null) {
      try {
        return await remoteDataSource!.createPatient({
          'first_name': patient.firstName,
          'last_name': patient.lastName,
          'username': patient.username,
          'email': patient.email,
          'phone': patient.phone,
          'address': patient.address,
          'gender': patient.gender,
          'birthday_date': patient.birthdayDate,
        });
      } catch (_) {}
    }
    final model = PatientModel(
      id: patient.id, firstName: patient.firstName, lastName: patient.lastName,
      username: patient.username, email: patient.email,
      phone: patient.phone, address: patient.address,
      gender: patient.gender, birthdayDate: patient.birthdayDate,
      isActive: patient.isActive, imageUrl: patient.imageUrl,
      roles: patient.roles,
    );
    dataSource.addPatient(model);
    return model;
  }

  @override
  Future<void> updatePatient(PatientEntity patient) async {
    if (remoteDataSource != null) {
      try {
        await remoteDataSource!.updatePatient(patient.id, {
          'first_name': patient.firstName,
          'last_name': patient.lastName,
          'username': patient.username,
          'email': patient.email,
          'phone': patient.phone,
          'address': patient.address,
          'gender': patient.gender,
          'birthday_date': patient.birthdayDate,
        });
        return;
      } catch (_) {}
    }
    dataSource.updatePatient(PatientModel(
      id: patient.id, firstName: patient.firstName, lastName: patient.lastName,
      username: patient.username, email: patient.email,
      phone: patient.phone, address: patient.address,
      gender: patient.gender, birthdayDate: patient.birthdayDate,
      isActive: patient.isActive, imageUrl: patient.imageUrl,
      roles: patient.roles,
    ));
  }

  @override
  Future<void> deletePatient(String id) async {
    if (remoteDataSource != null) {
      try {
        await remoteDataSource!.deletePatient(id);
        return;
      } catch (_) {}
    }
    dataSource.deletePatient(id);
  }

  @override
  Future<List<PatientEntity>> searchPatients(String query) async {
    if (remoteDataSource != null) {
      try {
        return await remoteDataSource!.getPatients(search: query);
      } catch (_) {}
    }
    return dataSource.searchPatients(query);
  }
}
