import 'package:clinic_management_app/data/models/user_model.dart';
import 'package:clinic_management_app/domain/entities/patient_entity.dart';

class PatientModel extends PatientEntity {
  const PatientModel({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.username,
    required super.email,
    super.phone,
    super.address,
    required super.gender,
    super.birthdayDate,
    super.roles = const [],
    super.isActive = true,
    super.imageUrl,
    super.countryId,
    super.cityId,
    super.fcmTokens,
    super.emailVerifiedAt,
    super.createdAt,
    super.updatedAt,
    super.patientId,
  });

  factory PatientModel.fromMap(Map<String, dynamic> map) {
    final userModel = UserModel.fromMap(map);
    final patientData = map['patient'] as Map<String, dynamic>?;

    return PatientModel(
      id: userModel.id,
      firstName: userModel.firstName,
      lastName: userModel.lastName,
      username: userModel.username,
      email: userModel.email,
      phone: userModel.phone,
      address: userModel.address,
      gender: userModel.gender,
      birthdayDate: userModel.birthdayDate,
      roles: userModel.roles,
      isActive: userModel.isActive,
      imageUrl: userModel.imageUrl,
      countryId: userModel.countryId,
      cityId: userModel.cityId,
      fcmTokens: userModel.fcmTokens,
      emailVerifiedAt: userModel.emailVerifiedAt,
      createdAt: userModel.createdAt,
      updatedAt: userModel.updatedAt,
      patientId: patientData?['id'] as String?,
    );
  }
}
