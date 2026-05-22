import 'package:clinic_management_app/domain/entities/user_entity.dart';

class AuthResult {
  final String accessToken;
  final String refreshToken;
  final int expiresIn;
  final UserEntity user;

  const AuthResult({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
    required this.user,
  });
}

abstract class AuthRepository {
  Future<AuthResult> login(String email, String password, {String? deviceFingerprint});
  Future<AuthResult> registerPatient({
    required String firstName, required String lastName, required String username,
    required String email, required String password, String? phone,
    String? address, required String gender, String? birthdayDate,
  });
  Future<AuthResult> registerDoctor({
    required String firstName, required String lastName, required String username,
    required String email, required String password, String? phone,
    String? address, required String gender, String? birthdayDate,
    required String specialization, required int experienceMonths,
  });
  Future<AuthResult> registerReceptionist({
    required String firstName, required String lastName, required String username,
    required String email, required String password, String? phone,
    String? address, required String gender, String? birthdayDate,
    String? shiftStart, String? shiftEnd,
  });
  Future<void> logout();
  Future<UserEntity> getProfile();
  Future<UserEntity> updateProfile(Map<String, dynamic> data);
  Future<void> changePassword(String oldPassword, String newPassword);
  Future<void> deleteAccount(String password);
}
