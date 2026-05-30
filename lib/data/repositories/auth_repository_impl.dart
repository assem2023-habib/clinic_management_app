import 'package:clinic_management_app/domain/repositories/auth_repository.dart';
import 'package:clinic_management_app/domain/entities/user_entity.dart';
import 'package:clinic_management_app/data/datasources/remote/auth_remote_datasource.dart';
import 'package:clinic_management_app/data/models/user_model.dart';
import 'package:clinic_management_app/data/models/auth/login_request.dart';
import 'package:clinic_management_app/data/models/auth/register_patient_request.dart';
import 'package:clinic_management_app/data/models/auth/register_doctor_request.dart';
import 'package:clinic_management_app/data/models/auth/auth_response.dart';
import 'package:clinic_management_app/core/services/api_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final ApiService _apiService;

  AuthRepositoryImpl(this._remoteDataSource, this._apiService);

  @override
  Future<AuthResponse> login(LoginRequest request) async {
    final json = await _remoteDataSource.login(request);
    final response = AuthResponse.fromMap(json);
    if (response.accessToken != null) {
      await _apiService.setToken(response.accessToken!);
      await _apiService.setRefreshToken(response.refreshToken!);
    }
    return response;
  }

  @override
  Future<AuthResponse> registerPatient(RegisterPatientRequest request) async {
    final json = await _remoteDataSource.registerPatient(request);
    final response = AuthResponse.fromMap(json);
    if (response.accessToken != null) {
      await _apiService.setToken(response.accessToken!);
      await _apiService.setRefreshToken(response.refreshToken!);
    }
    return response;
  }

  @override
  Future<AuthResponse> registerDoctor(RegisterDoctorRequest request) async {
    final json = await _remoteDataSource.registerDoctor(request);
    return AuthResponse.fromMap(json);
  }

  @override
  Future<void> logout() async {
    await _remoteDataSource.logout();
    await _apiService.clearTokens();
  }

  @override
  Future<UserEntity> getProfile() async {
    final json = await _remoteDataSource.getProfile();
    final data = json['data'] as Map<String, dynamic>;
    return UserModel.fromMap(data);
  }

  @override
  Future<UserEntity> updateProfile(Map<String, dynamic> data) async {
    final json = await _remoteDataSource.updateProfile(data);
    final responseData = json['data'] as Map<String, dynamic>;
    return UserModel.fromMap(responseData);
  }

  @override
  Future<void> changePassword(String oldPassword, String newPassword) async {
    await _remoteDataSource.changePassword(oldPassword, newPassword);
  }

  @override
  Future<void> deleteAccount(String password) async {
    await _remoteDataSource.deleteAccount(password);
  }
}
