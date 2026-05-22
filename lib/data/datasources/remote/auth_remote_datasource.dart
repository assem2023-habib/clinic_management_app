import 'package:clinic_management_app/core/services/api_service.dart';

class AuthRemoteDataSource {
  final ApiService _api;

  AuthRemoteDataSource(this._api);

  Future<Map<String, dynamic>> login(String email, String password, {String? deviceFingerprint}) async {
    final response = await _api.post('/auth/login', data: {
      'email': email,
      'password': password,
      if (deviceFingerprint != null) 'device_fingerprint': deviceFingerprint,
    });
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> register(Map<String, dynamic> data, String endpoint) async {
    final response = await _api.post('/auth/register/$endpoint', data: data);
    return response.data as Map<String, dynamic>;
  }

  Future<void> logout() async {
    await _api.post('/auth/logout');
  }

  Future<Map<String, dynamic>> getProfile() async {
    final response = await _api.get('/auth/me');
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> data) async {
    final response = await _api.put('/auth/me', data: data);
    return response.data as Map<String, dynamic>;
  }

  Future<void> changePassword(String oldPassword, String newPassword) async {
    await _api.put('/auth/password', data: {
      'old_password': oldPassword,
      'new_password': newPassword,
    });
  }

  Future<void> deleteAccount(String password) async {
    await _api.delete('/auth/account');
  }
}
