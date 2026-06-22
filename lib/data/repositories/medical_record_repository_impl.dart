import 'package:clinic_management_app/data/datasources/remote/medical_record_remote_datasource.dart';
import 'package:clinic_management_app/data/models/medical_record_model.dart';
import 'package:clinic_management_app/domain/entities/medical_record_entity.dart';
import 'package:clinic_management_app/domain/repositories/medical_record_repository.dart';

class MedicalRecordRepositoryImpl implements MedicalRecordRepository {
  final MedicalRecordRemoteDataSource? remoteDataSource;

  MedicalRecordRepositoryImpl({this.remoteDataSource});

  @override
  Future<List<MedicalRecordEntity>> getAllRecords({String? patientId, String? doctorId, int page = 1, int limit = 20}) async {
    if (remoteDataSource != null) {
      try {
        return await remoteDataSource!.getMedicalRecords(patientId: patientId, doctorId: doctorId, page: page, limit: limit);
      } catch (_) {}
    }
    return _mockRecords.where((r) {
      if (patientId != null && r.patientId != patientId) return false;
      if (doctorId != null && r.doctorId != doctorId) return false;
      return true;
    }).toList();
  }

  @override
  Future<MedicalRecordEntity> getRecordById(String id) async {
    if (remoteDataSource != null) {
      try {
        return await remoteDataSource!.getMedicalRecordById(id);
      } catch (_) {}
    }
    return _mockRecords.firstWhere((r) => r.id == id);
  }

  @override
  Future<MedicalRecordEntity> createRecord(MedicalRecordEntity record) async {
    if (remoteDataSource != null) {
      try {
        return await remoteDataSource!.createMedicalRecord({
          'patient_id': record.patientId,
          'doctor_id': record.doctorId,
          'diagnosis': record.diagnosis,
          'notes': record.notes,
        });
      } catch (_) {}
    }
    return record;
  }

  static final List<MedicalRecordEntity> _mockRecords = [
    MedicalRecordModel(
      id: 'rec-1', patientId: 'pat-1', doctorId: 'doc-1',
      diagnosis: 'تشخيص عام', notes: 'متابعة دورية',
      createdAt: '2025-01-15T10:30:00Z',
    ),
    MedicalRecordModel(
      id: 'rec-2', patientId: 'pat-2', doctorId: 'doc-1',
      diagnosis: 'التهاب الحلق', notes: 'يحتاج مضاد حيوي',
      createdAt: '2025-01-20T14:00:00Z',
    ),
  ];
}
