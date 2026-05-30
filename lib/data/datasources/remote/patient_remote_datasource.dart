import 'package:clinic_management_app/core/services/api_service.dart';
import 'package:clinic_management_app/data/models/patient_model.dart';

class PatientRemoteDataSource {
  final ApiService _api;

  PatientRemoteDataSource(this._api);

  Future<List<PatientModel>> getPatients({int page = 1, int limit = 20, String? search, String? gender, String? dateFrom, String? dateTo, bool? isActive}) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'limit': limit,
      if (search != null) 'search': search,
      if (gender != null) 'gender': gender,
      if (dateFrom != null) 'date_from': dateFrom,
      if (dateTo != null) 'date_to': dateTo,
      if (isActive != null) 'is_active': isActive ? '1' : '0',
    };
    final response = await _api.get('/patients', queryParameters: queryParams);
    final data = response.data['data'] as List<dynamic>? ?? [];
    return data.map((e) => PatientModel.fromMap(e as Map<String, dynamic>)).toList();
  }

  Future<PatientModel> getPatientById(String id) async {
    final response = await _api.get('/patients/$id');
    final data = response.data['data'] as Map<String, dynamic>;
    return PatientModel.fromMap(data);
  }

  Future<PatientModel> createPatient(Map<String, dynamic> body) async {
    final response = await _api.post('/patients', data: body);
    final data = response.data['data'] as Map<String, dynamic>;
    return PatientModel.fromMap(data);
  }

  Future<PatientModel> updatePatient(String id, Map<String, dynamic> body) async {
    final response = await _api.put('/patients/$id', data: body);
    final data = response.data['data'] as Map<String, dynamic>;
    return PatientModel.fromMap(data);
  }

  Future<PatientModel> partialUpdatePatient(String id, Map<String, dynamic> body) async {
    final response = await _api.put('/patients/$id', data: body);
    final data = response.data['data'] as Map<String, dynamic>;
    return PatientModel.fromMap(data);
  }

  Future<void> deletePatient(String id) async {
    await _api.delete('/patients/$id');
  }
}
