import 'package:clinic_management_app/data/datasources/data_source.dart';
import 'package:clinic_management_app/data/models/patient_model.dart';
import 'package:clinic_management_app/domain/entities/patient_entity.dart';
import 'package:clinic_management_app/domain/repositories/patient_repository.dart';

class PatientRepositoryImpl implements PatientRepository {
  final DataSource dataSource;

  PatientRepositoryImpl(this.dataSource);

  @override
  Future<List<PatientEntity>> getAllPatients() async => dataSource.allPatients;

  @override
  Future<PatientEntity?> getPatientById(String id) async => dataSource.patientById(id);

  @override
  Future<void> addPatient(PatientEntity patient) async {
    dataSource.addPatient(PatientModel(
      id: patient.id, name: patient.name, age: patient.age,
      gender: patient.gender, phone: patient.phone, email: patient.email,
      address: patient.address, bloodType: patient.bloodType,
      registeredDate: patient.registeredDate,
    ));
  }

  @override
  Future<void> updatePatient(PatientEntity patient) async {
    dataSource.updatePatient(PatientModel(
      id: patient.id, name: patient.name, age: patient.age,
      gender: patient.gender, phone: patient.phone, email: patient.email,
      address: patient.address, bloodType: patient.bloodType,
      registeredDate: patient.registeredDate,
    ));
  }

  @override
  Future<void> deletePatient(String id) async => dataSource.deletePatient(id);

  @override
  Future<List<PatientEntity>> searchPatients(String query) async => dataSource.searchPatients(query);
}
