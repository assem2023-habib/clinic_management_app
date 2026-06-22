import 'package:clinic_management_app/core/services/api_service.dart';
import 'package:clinic_management_app/data/models/receptionist_model.dart';

class ReceptionistRemoteDataSource {
  final ApiService _api;

  ReceptionistRemoteDataSource(this._api);

  Future<List<ReceptionistModel>> getReceptionists({int page = 1, int limit = 20, String? search, String? gender, bool? isActive}) async {
    final queryParams = <String, dynamic>{
      'page': page, 'limit': limit,
      'search': ?search,
      'gender': ?gender,
      'is_active': ?isActive,
    };
    final response = await _api.get('/receptionists', queryParameters: queryParams);
    final data = response.data['data'] as List<dynamic>? ?? [];
    return data.map((e) => ReceptionistModel.fromMap(e as Map<String, dynamic>)).toList();
  }

  Future<ReceptionistModel> getReceptionistById(String id) async {
    final response = await _api.get('/receptionists/$id');
    final data = response.data['data'] as Map<String, dynamic>;
    return ReceptionistModel.fromMap(data);
  }

  Future<ReceptionistModel> createReceptionist(Map<String, dynamic> body) async {
    final response = await _api.post('/receptionists', data: body);
    final data = response.data['data'] as Map<String, dynamic>;
    return ReceptionistModel.fromMap(data);
  }

  Future<ReceptionistModel> updateReceptionist(String id, Map<String, dynamic> body) async {
    final response = await _api.put('/receptionists/$id', data: body);
    final data = response.data['data'] as Map<String, dynamic>;
    return ReceptionistModel.fromMap(data);
  }

  Future<void> deleteReceptionist(String id) async {
    await _api.delete('/receptionists/$id');
  }

  Future<Map<String, dynamic>> activateAccount(String id) async {
    final response = await _api.put('/receptionists/$id/activate-account');
    return response.data as Map<String, dynamic>;
  }
}
