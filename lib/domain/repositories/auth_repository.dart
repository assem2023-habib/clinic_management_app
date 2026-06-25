import 'package:clinic_management_app/domain/entities/user_entity.dart';
import 'package:clinic_management_app/domain/entities/auth_entity.dart';

abstract class AuthRepository {
  Future<AuthResponseEntity> login(LoginRequestEntity request);
  Future<AuthResponseEntity> registerPatient(RegisterPatientRequestEntity request);
  Future<AuthResponseEntity> registerDoctor(RegisterDoctorRequestEntity request);
  Future<AuthResponseEntity> registerReceptionist(RegisterReceptionistRequestEntity request);
  Future<void> logout();
  Future<UserEntity> getProfile();
  Future<UserEntity> updateProfile(Map<String, dynamic> data);
  Future<void> changePassword(String oldPassword, String newPassword);
  Future<void> deleteAccount(String password);
  Future<void> updateDeviceToken(String token);
  Future<Map<String, String>> getFirebaseToken();
}
