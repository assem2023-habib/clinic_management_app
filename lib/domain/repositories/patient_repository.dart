import 'package:clinic_management_app/domain/entities/patient_entity.dart';

abstract class PatientRepository {
  Future<List<PatientEntity>> getAllPatients({String? query, String? gender, bool? isActive});
  Future<PatientEntity?> getPatientById(String id);
  Future<PatientEntity> createPatient(PatientEntity patient);
  Future<void> addPatient(PatientEntity patient);
  Future<void> updatePatient(PatientEntity patient);
  Future<void> deletePatient(String id);
  Future<List<PatientEntity>> searchPatients(String query);
}
