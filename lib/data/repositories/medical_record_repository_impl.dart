import 'package:clinic_management_app/data/datasources/data_source.dart';
import 'package:clinic_management_app/data/models/medical_record_model.dart';
import 'package:clinic_management_app/domain/entities/medical_record_entity.dart';
import 'package:clinic_management_app/domain/repositories/medical_record_repository.dart';

class MedicalRecordRepositoryImpl implements MedicalRecordRepository {
  final DataSource dataSource;

  MedicalRecordRepositoryImpl(this.dataSource);

  @override
  Future<List<MedicalRecordEntity>> getAllRecords() async => dataSource.allMedicalRecords;

  @override
  Future<List<MedicalRecordEntity>> getRecordsByPatient(String patientId) async =>
      dataSource.allMedicalRecords.where((r) => r.patientId == patientId).toList();

  @override
  Future<void> addRecord(MedicalRecordEntity record) async {
    dataSource.addMedicalRecord(MedicalRecordModel(
      id: record.id, patientId: record.patientId,
      doctorId: record.doctorId, diagnosis: record.diagnosis,
      notes: record.notes, createdAt: record.createdAt,
    ));
  }
}
