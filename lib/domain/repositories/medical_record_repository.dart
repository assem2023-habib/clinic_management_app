import 'package:clinic_management_app/domain/entities/medical_record_entity.dart';

abstract class MedicalRecordRepository {
  Future<List<MedicalRecordEntity>> getAllRecords();
  Future<List<MedicalRecordEntity>> getRecordsByPatient(String patientId);
  Future<void> addRecord(MedicalRecordEntity record);
}
