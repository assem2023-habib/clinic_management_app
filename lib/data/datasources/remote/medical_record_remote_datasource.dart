import 'package:clinic_management_app/core/services/api_service.dart';
import 'package:clinic_management_app/data/models/medical_record_model.dart';

class MedicalRecordRemoteDataSource {
  final ApiService _api;

  MedicalRecordRemoteDataSource(this._api);

  Future<List<MedicalRecordModel>> getMedicalRecords({int page = 1, int limit = 20, String? patientId, String? doctorId}) async {
    final queryParams = <String, dynamic>{'page': page, 'limit': limit};
    if (patientId != null) queryParams['patient_id'] = patientId;
    if (doctorId != null) queryParams['doctor_id'] = doctorId;
    final response = await _api.get('/medical-records', queryParameters: queryParams);
    final data = response.data['data'] as List<dynamic>? ?? [];
    return data.map((e) => MedicalRecordModel.fromMap(e as Map<String, dynamic>)).toList();
  }

  Future<MedicalRecordModel> getMedicalRecordById(String id) async {
    final response = await _api.get('/medical-records/$id');
    final data = response.data['data'] as Map<String, dynamic>;
    return MedicalRecordModel.fromMap(data);
  }

  Future<MedicalRecordModel> createMedicalRecord(Map<String, dynamic> body) async {
    final response = await _api.post('/medical-records', data: body);
    final data = response.data['data'] as Map<String, dynamic>;
    return MedicalRecordModel.fromMap(data);
  }

  Future<List<MedicalRecordModel>> getRecordsByPatient(String patientId) async {
    return getMedicalRecords(patientId: patientId);
  }
}
