import 'package:clinic_management_app/domain/entities/user_entity.dart';
import 'package:clinic_management_app/data/models/auth/login_request.dart';
import 'package:clinic_management_app/data/models/auth/register_patient_request.dart';
import 'package:clinic_management_app/data/models/auth/register_doctor_request.dart';
import 'package:clinic_management_app/data/models/auth/auth_response.dart';

abstract class AuthRepository {
  Future<AuthResponse> login(LoginRequest request);
  Future<AuthResponse> registerPatient(RegisterPatientRequest request);
  Future<AuthResponse> registerDoctor(RegisterDoctorRequest request);
  Future<void> logout();
  Future<UserEntity> getProfile();
  Future<UserEntity> updateProfile(Map<String, dynamic> data);
  Future<void> changePassword(String oldPassword, String newPassword);
  Future<void> deleteAccount(String password);
  Future<void> updateDeviceToken(String token);
  Future<Map<String, String>> getFirebaseToken();
}
