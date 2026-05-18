import 'package:clinic_management_app/data/models/medical_record.dart';
import 'package:clinic_management_app/data/mock/mock_data.dart';

class MedicalRecordRepository {
  final List<MedicalRecord> _records = List.from(MockData.medicalRecords);

  Future<List<MedicalRecord>> getAllRecords() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_records);
  }

  Future<List<MedicalRecord>> getRecordsByPatient(String patientId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _records.where((r) => r.patientId == patientId).toList();
  }

  Future<void> addRecord(MedicalRecord record) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _records.add(record);
  }

  Future<void> updateRecord(MedicalRecord record) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _records.indexWhere((r) => r.id == record.id);
    if (index != -1) {
      _records[index] = record;
    }
  }

  Future<void> deleteRecord(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _records.removeWhere((r) => r.id == id);
  }
}
