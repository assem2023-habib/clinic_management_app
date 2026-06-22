import 'package:clinic_management_app/domain/entities/medical_record_entity.dart';

abstract class MedicalRecordRepository {
  Future<List<MedicalRecordEntity>> getAllRecords({String? patientId, String? doctorId, int page = 1, int limit = 20});
  Future<MedicalRecordEntity> getRecordById(String id);
  Future<MedicalRecordEntity> createRecord(MedicalRecordEntity record);
}
