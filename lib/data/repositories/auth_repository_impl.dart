import 'package:clinic_management_app/domain/repositories/auth_repository.dart';
import 'package:clinic_management_app/domain/entities/user_entity.dart';
import 'package:clinic_management_app/data/datasources/remote/auth_remote_datasource.dart';
import 'package:clinic_management_app/data/models/user_model.dart';
import 'package:clinic_management_app/core/services/api_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final ApiService _apiService;

  AuthRepositoryImpl(this._remoteDataSource, this._apiService);

  @override
  Future<AuthResult> login(String email, String password, {String? deviceFingerprint}) async {
    final json = await _remoteDataSource.login(email, password, deviceFingerprint: deviceFingerprint);
    final data = json['data'] as Map<String, dynamic>;

    final accessToken = data['access_token'] as String;
    final refreshToken = data['refresh_token'] as String;
    final expiresIn = data['expires_in'] as int;
    final user = UserModel.fromMap(data['user'] as Map<String, dynamic>);

    await _apiService.setToken(accessToken);
    await _apiService.setRefreshToken(refreshToken);

    return AuthResult(accessToken: accessToken, refreshToken: refreshToken, expiresIn: expiresIn, user: user);
  }

  @override
  Future<AuthResult> registerPatient({
    required String firstName, required String lastName, required String username,
    required String email, required String password, String? phone,
    String? address, required String gender, String? birthdayDate,
  }) async {
    final json = await _remoteDataSource.register({
      'first_name': firstName, 'last_name': lastName, 'username': username,
      'email': email, 'password': password, 'phone': phone, 'address': address,
      'gender': gender, 'birthday_date': birthdayDate,
    }, 'patient');
    return _handleRegisterResponse(json);
  }

  @override
  Future<AuthResult> registerDoctor({
    required String firstName, required String lastName, required String username,
    required String email, required String password, String? phone,
    String? address, required String gender, String? birthdayDate,
    required String specialization, required int experienceMonths,
  }) async {
    final json = await _remoteDataSource.register({
      'first_name': firstName, 'last_name': lastName, 'username': username,
      'email': email, 'password': password, 'phone': phone, 'address': address,
      'gender': gender, 'birthday_date': birthdayDate,
      'specialization': specialization, 'experience_months': experienceMonths,
    }, 'doctor');
    return _handleRegisterResponse(json);
  }

  @override
  Future<AuthResult> registerReceptionist({
    required String firstName, required String lastName, required String username,
    required String email, required String password, String? phone,
    String? address, required String gender, String? birthdayDate,
    String? shiftStart, String? shiftEnd,
  }) async {
    final json = await _remoteDataSource.register({
      'first_name': firstName, 'last_name': lastName, 'username': username,
      'email': email, 'password': password, 'phone': phone, 'address': address,
      'gender': gender, 'birthday_date': birthdayDate,
      'shift_start': shiftStart, 'shift_end': shiftEnd,
    }, 'receptionist');
    return _handleRegisterResponse(json);
  }

  AuthResult _handleRegisterResponse(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    final accessToken = data['access_token'] as String;
    final refreshToken = data['refresh_token'] as String;
    final expiresIn = data['expires_in'] as int;
    final user = UserModel.fromMap(data['user'] as Map<String, dynamic>);
    return AuthResult(accessToken: accessToken, refreshToken: refreshToken, expiresIn: expiresIn, user: user);
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
