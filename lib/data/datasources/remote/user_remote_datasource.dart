import 'package:clinic_management_app/core/services/api_service.dart';
import 'package:clinic_management_app/data/models/user_model.dart';

class UserRemoteDataSource {
  final ApiService _api;

  UserRemoteDataSource(this._api);

  Future<List<UserModel>> getUsers({int page = 1, int limit = 20, String? role, String? search, String? gender, bool? isActive, String? dateFrom, String? dateTo, String? sort, String? order}) async {
    final queryParams = <String, dynamic>{
      'page': page, 'limit': limit,
      'role': ?role,
      'search': ?search,
      'gender': ?gender,
      'is_active': ?isActive,
      'date_from': ?dateFrom,
      'date_to': ?dateTo,
      'sort': ?sort,
      'order': ?order,
    };
    final response = await _api.get('/users', queryParameters: queryParams);
    final data = response.data['data'] as List<dynamic>? ?? [];
    return data.map((e) => UserModel.fromMap(e as Map<String, dynamic>)).toList();
  }

  Future<UserModel> getUserById(String id) async {
    final response = await _api.get('/users/$id');
    final data = response.data['data'] as Map<String, dynamic>;
    return UserModel.fromMap(data);
  }

  Future<UserModel> updateUser(String id, Map<String, dynamic> body) async {
    final response = await _api.put('/users/$id', data: body);
    final data = response.data['data'] as Map<String, dynamic>;
    return UserModel.fromMap(data);
  }

  Future<Map<String, dynamic>> toggleActive(String id) async {
    final response = await _api.put('/users/$id/toggle-active');
    return response.data as Map<String, dynamic>;
  }

  Future<void> deleteUser(String id) async {
    await _api.delete('/users/$id');
  }
}
