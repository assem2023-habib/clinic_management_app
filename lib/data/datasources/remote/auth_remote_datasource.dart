import 'package:clinic_management_app/core/services/api_service.dart';
import 'package:clinic_management_app/data/models/auth/login_request.dart';
import 'package:clinic_management_app/data/models/auth/register_patient_request.dart';
import 'package:clinic_management_app/data/models/auth/register_doctor_request.dart';

class AuthRemoteDataSource {
  final ApiService _api;

  AuthRemoteDataSource(this._api);

  Future<Map<String, dynamic>> login(LoginRequest request) async {
    final response = await _api.post('/auth/login', data: request.toMap());
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> registerPatient(RegisterPatientRequest request) async {
    final response = await _api.post('/auth/register/patient', data: request.toMap());
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> registerDoctor(RegisterDoctorRequest request) async {
    final response = await _api.post('/auth/register/doctor', data: request.toMap());
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
