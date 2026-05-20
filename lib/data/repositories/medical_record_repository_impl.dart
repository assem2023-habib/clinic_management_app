import 'package:clinic_management_app/data/datasources/local/mock_datasource.dart';
import 'package:clinic_management_app/data/models/medical_record_model.dart';
import 'package:clinic_management_app/domain/entities/medical_record_entity.dart';
import 'package:clinic_management_app/domain/repositories/medical_record_repository.dart';

class MedicalRecordRepositoryImpl implements MedicalRecordRepository {
  final MockDataSource dataSource;

  MedicalRecordRepositoryImpl(this.dataSource);

  @override
  Future<List<MedicalRecordEntity>> getAllRecords() async => dataSource.allMedicalRecords;

  @override
  Future<List<MedicalRecordEntity>> getRecordsByPatient(String patientId) async =>
      dataSource.allMedicalRecords.where((r) => r.patientId == patientId).toList();

  @override
  Future<void> addRecord(MedicalRecordEntity record) async {
    dataSource.addMedicalRecord(MedicalRecordModel(
      id: record.id, patientId: record.patientId, patientName: record.patientName,
      doctorId: record.doctorId, doctorName: record.doctorName, visitDate: record.visitDate,
      diagnosis: record.diagnosis, prescription: record.prescription, notes: record.notes,
    ));
  }
}
