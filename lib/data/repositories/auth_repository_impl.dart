import 'package:clinic_management_app/domain/repositories/auth_repository.dart';
import 'package:clinic_management_app/domain/entities/user_entity.dart';
import 'package:clinic_management_app/domain/entities/auth_entity.dart';
import 'package:clinic_management_app/data/datasources/remote/auth_remote_datasource.dart';
import 'package:clinic_management_app/data/models/user_model.dart';
import 'package:clinic_management_app/data/models/auth/login_request.dart';
import 'package:clinic_management_app/data/models/auth/register_patient_request.dart';
import 'package:clinic_management_app/data/models/auth/register_doctor_request.dart';
import 'package:clinic_management_app/data/models/auth/register_receptionist_request.dart';
import 'package:clinic_management_app/data/models/auth/auth_response.dart';
import 'package:clinic_management_app/core/services/api_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final ApiService _apiService;

  AuthRepositoryImpl(this._remoteDataSource, this._apiService);

  @override
  Future<AuthResponseEntity> login(LoginRequestEntity request) async {
    final dataRequest = LoginRequest(
      email: request.email,
      password: request.password,
      deviceFingerprint: request.deviceFingerprint,
    );
    final json = await _remoteDataSource.login(dataRequest);
    final response = AuthResponse.fromMap(json);
    if (response.accessToken != null) {
      await _apiService.setToken(response.accessToken!);
      await _apiService.setRefreshToken(response.refreshToken!);
    }
    return _toEntity(response);
  }

  @override
  Future<AuthResponseEntity> registerPatient(RegisterPatientRequestEntity request) async {
    final dataRequest = RegisterPatientRequest(
      firstName: request.firstName,
      lastName: request.lastName,
      username: request.username,
      email: request.email,
      password: request.password,
      phone: request.phone,
      address: request.address,
      gender: request.gender,
      birthdayDate: request.birthdayDate,
      cityId: request.cityId,
    );
    final json = await _remoteDataSource.registerPatient(dataRequest);
    final response = AuthResponse.fromMap(json);
    if (response.accessToken != null) {
      await _apiService.setToken(response.accessToken!);
      await _apiService.setRefreshToken(response.refreshToken!);
    }
    return _toEntity(response);
  }

  @override
  Future<AuthResponseEntity> registerDoctor(RegisterDoctorRequestEntity request) async {
    final dataRequest = RegisterDoctorRequest(
      firstName: request.firstName,
      lastName: request.lastName,
      username: request.username,
      email: request.email,
      password: request.password,
      phone: request.phone,
      address: request.address,
      gender: request.gender,
      birthdayDate: request.birthdayDate,
      cityId: request.cityId,
      specializationId: request.specializationId,
      experienceMonths: request.experienceMonths,
    );
    final json = await _remoteDataSource.registerDoctor(dataRequest);
    final response = AuthResponse.fromMap(json);
    return _toEntity(response);
  }

  @override
  Future<AuthResponseEntity> registerReceptionist(RegisterReceptionistRequestEntity request) async {
    final dataRequest = RegisterReceptionistRequest(
      firstName: request.firstName,
      lastName: request.lastName,
      username: request.username,
      email: request.email,
      password: request.password,
      phone: request.phone,
      address: request.address,
      gender: request.gender,
      birthdayDate: request.birthdayDate,
      cityId: request.cityId,
      shiftStart: request.shiftStart,
      shiftEnd: request.shiftEnd,
    );
    final json = await _remoteDataSource.registerReceptionist(dataRequest);
    final response = AuthResponse.fromMap(json);
    return _toEntity(response);
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

  @override
  Future<void> updateDeviceToken(String token) async {
    await _remoteDataSource.updateDeviceToken(token);
  }

  @override
  Future<Map<String, String>> getFirebaseToken() async {
    final json = await _remoteDataSource.getFirebaseToken();
    final data = json['data'] as Map<String, dynamic>;
    return {
      'firebase_token': data['firebase_token'] as String,
      'uid': data['uid'] as String,
    };
  }

  AuthResponseEntity _toEntity(AuthResponse response) {
    return AuthResponseEntity(
      accessToken: response.accessToken,
      refreshToken: response.refreshToken,
      expiresIn: response.expiresIn,
      tokenType: response.tokenType,
      user: response.user,
      message: response.message,
    );
  }
}
