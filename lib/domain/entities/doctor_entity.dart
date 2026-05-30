import 'package:clinic_management_app/domain/entities/user_entity.dart';
import 'package:clinic_management_app/domain/entities/role_entity.dart';
import 'package:clinic_management_app/domain/entities/specialization_entity.dart';
import 'package:clinic_management_app/domain/entities/doctor_schedule_entity.dart';

class DoctorEntity extends UserEntity {
  final SpecializationEntity? specialization;
  final int? experienceMonths;
  final List<DoctorScheduleEntity> schedules;

  const DoctorEntity({
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
    this.specialization,
    this.experienceMonths,
    this.schedules = const [],
  });

  factory DoctorEntity.fromUser(UserEntity user, {
    SpecializationEntity? specialization,
    int? experienceMonths,
    List<DoctorScheduleEntity> schedules = const [],
  }) {
    return DoctorEntity(
      id: user.id,
      firstName: user.firstName,
      lastName: user.lastName,
      username: user.username,
      email: user.email,
      phone: user.phone,
      address: user.address,
      gender: user.gender,
      birthdayDate: user.birthdayDate,
      roles: user.roles,
      isActive: user.isActive,
      imageUrl: user.imageUrl,
      countryId: user.countryId,
      cityId: user.cityId,
      fcmTokens: user.fcmTokens,
      emailVerifiedAt: user.emailVerifiedAt,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
      specialization: specialization,
      experienceMonths: experienceMonths,
      schedules: schedules,
    );
  }

  @override
  DoctorEntity copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? username,
    String? email,
    String? phone,
    String? address,
    String? gender,
    String? birthdayDate,
    List<RoleEntity>? roles,
    bool? isActive,
    String? imageUrl,
    String? countryId,
    String? cityId,
    List<String>? fcmTokens,
    String? emailVerifiedAt,
    String? createdAt,
    String? updatedAt,
    SpecializationEntity? specialization,
    int? experienceMonths,
    List<DoctorScheduleEntity>? schedules,
  }) {
    return DoctorEntity(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      username: username ?? this.username,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      gender: gender ?? this.gender,
      birthdayDate: birthdayDate ?? this.birthdayDate,
      roles: roles ?? this.roles,
      isActive: isActive ?? this.isActive,
      imageUrl: imageUrl ?? this.imageUrl,
      countryId: countryId ?? this.countryId,
      cityId: cityId ?? this.cityId,
      fcmTokens: fcmTokens ?? this.fcmTokens,
      emailVerifiedAt: emailVerifiedAt ?? this.emailVerifiedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      specialization: specialization ?? this.specialization,
      experienceMonths: experienceMonths ?? this.experienceMonths,
      schedules: schedules ?? this.schedules,
    );
  }

  @override
  List<Object?> get props => [
    ...super.props,
    specialization,
    experienceMonths,
    schedules,
  ];
}
