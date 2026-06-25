import 'package:clinic_management_app/domain/entities/user_entity.dart';

class AuthResponseEntity {
  final String? accessToken;
  final String? refreshToken;
  final int? expiresIn;
  final String? tokenType;
  final UserEntity? user;
  final String? message;

  const AuthResponseEntity({
    this.accessToken,
    this.refreshToken,
    this.expiresIn,
    this.tokenType,
    this.user,
    this.message,
  });

  bool get isAuthenticated => accessToken != null;
}

class LoginRequestEntity {
  final String email;
  final String password;
  final String? deviceFingerprint;

  const LoginRequestEntity({
    required this.email,
    required this.password,
    this.deviceFingerprint,
  });
}

class RegisterPatientRequestEntity {
  final String firstName;
  final String lastName;
  final String username;
  final String email;
  final String password;
  final String? phone;
  final String? address;
  final String gender;
  final String? birthdayDate;
  final String? cityId;

  const RegisterPatientRequestEntity({
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    required this.password,
    this.phone,
    this.address,
    required this.gender,
    this.birthdayDate,
    this.cityId,
  });
}

class RegisterDoctorRequestEntity extends RegisterPatientRequestEntity {
  final String specializationId;
  final int experienceMonths;

  const RegisterDoctorRequestEntity({
    required super.firstName,
    required super.lastName,
    required super.username,
    required super.email,
    required super.password,
    super.phone,
    super.address,
    required super.gender,
    super.birthdayDate,
    super.cityId,
    required this.specializationId,
    required this.experienceMonths,
  });
}

class RegisterReceptionistRequestEntity extends RegisterPatientRequestEntity {
  final String? shiftStart;
  final String? shiftEnd;

  const RegisterReceptionistRequestEntity({
    required super.firstName,
    required super.lastName,
    required super.username,
    required super.email,
    required super.password,
    super.phone,
    super.address,
    required super.gender,
    super.birthdayDate,
    super.cityId,
    this.shiftStart,
    this.shiftEnd,
  });
}
