import 'package:clinic_management_app/data/models/user_model.dart';
import 'package:clinic_management_app/data/models/specialization_model.dart';
import 'package:clinic_management_app/data/models/doctor_schedule_model.dart';
import 'package:clinic_management_app/domain/entities/doctor_entity.dart';
import 'package:clinic_management_app/domain/entities/specialization_entity.dart';

class DoctorModel extends DoctorEntity {
  const DoctorModel({
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
    super.specialization,
    super.experienceMonths,
    super.schedules = const [],
  });

  factory DoctorModel.fromMap(Map<String, dynamic> map) {
    final userModel = UserModel.fromMap(map);

    SpecializationEntity? specialization;
    int? experienceMonths;
    List<DoctorScheduleModel> schedules = const [];

    final doctorData = map['doctor'] as Map<String, dynamic>?;
    final source = doctorData ?? map;

    if (source['specialization'] != null && source['specialization'] is Map) {
      specialization = SpecializationModel.fromMap(source['specialization'] as Map<String, dynamic>);
    }
    experienceMonths = source['experience_months'] as int?;
    if (source['schedules'] != null && source['schedules'] is List) {
      schedules = (source['schedules'] as List)
          .map((s) => DoctorScheduleModel.fromMap(s as Map<String, dynamic>))
          .toList();
    }

    return DoctorModel(
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
      specialization: specialization,
      experienceMonths: experienceMonths,
      schedules: schedules,
    );
  }
}
