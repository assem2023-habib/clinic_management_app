import 'package:clinic_management_app/core/services/api_service.dart';

class RatingRemoteDataSource {
  final ApiService _api;

  RatingRemoteDataSource(this._api);

  Future<Map<String, dynamic>> getAllRatings({Map<String, dynamic>? queryParams}) async {
    final response = await _api.get('/ratings', queryParameters: queryParams);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getRatingById(String id) async {
    final response = await _api.get('/ratings/$id');
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> createRating(Map<String, dynamic> data) async {
    final response = await _api.post('/ratings', data: data);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> updateRating(String id, Map<String, dynamic> data) async {
    final response = await _api.put('/ratings/$id', data: data);
    return response.data as Map<String, dynamic>;
  }

  Future<void> deleteRating(String id) async {
    await _api.delete('/ratings/$id');
  }
}
