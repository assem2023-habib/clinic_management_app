import 'package:clinic_management_app/domain/entities/user_entity.dart';
import 'package:clinic_management_app/domain/entities/role_entity.dart';
import 'package:clinic_management_app/domain/entities/specialization_entity.dart';
import 'package:clinic_management_app/domain/entities/doctor_schedule_entity.dart';
import 'package:clinic_management_app/domain/entities/review_entity.dart';

class DoctorEntity extends UserEntity {
  final SpecializationEntity? specialization;
  final int? experienceMonths;
  final List<DoctorScheduleEntity> schedules;
  final double? rating;
  final int? reviewsCount;
  final List<ReviewEntity> recentReviews;
  final List<String> services;
  final String? bio;
  final String? clinicAddress;
  final String? clinicName;
  final List<String> languages;
  final List<String> qualifications;
  final String? education;
  final int? patientsCount;
  final int? surgeriesCount;
  final String? supervisionRequestStatus;

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
    this.rating,
    this.reviewsCount,
    this.recentReviews = const [],
    this.services = const [],
    this.bio,
    this.clinicAddress,
    this.clinicName,
    this.languages = const [],
    this.qualifications = const [],
    this.education,
    this.patientsCount,
    this.surgeriesCount,
    this.supervisionRequestStatus,
  });

  String get name => fullName;
  String get specialty => specialization?.nameAr ?? '';

  int get experienceYears => experienceMonths != null ? experienceMonths! ~/ 12 : 0;
  bool get isAvailable => isActive;

  factory DoctorEntity.fromUser(UserEntity user, {
    SpecializationEntity? specialization,
    int? experienceMonths,
    List<DoctorScheduleEntity> schedules = const [],
    List<ReviewEntity> recentReviews = const [],
    String? supervisionRequestStatus,
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
      recentReviews: recentReviews,
      supervisionRequestStatus: supervisionRequestStatus,
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
    double? rating,
    int? reviewsCount,
    List<ReviewEntity>? recentReviews,
    List<String>? services,
    String? bio,
    String? clinicAddress,
    String? clinicName,
    List<String>? languages,
    List<String>? qualifications,
    String? education,
    int? patientsCount,
    int? surgeriesCount,
    String? supervisionRequestStatus,
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
      rating: rating ?? this.rating,
      reviewsCount: reviewsCount ?? this.reviewsCount,
      recentReviews: recentReviews ?? this.recentReviews,
      services: services ?? this.services,
      bio: bio ?? this.bio,
      clinicAddress: clinicAddress ?? this.clinicAddress,
      clinicName: clinicName ?? this.clinicName,
      languages: languages ?? this.languages,
      qualifications: qualifications ?? this.qualifications,
      education: education ?? this.education,
      patientsCount: patientsCount ?? this.patientsCount,
      surgeriesCount: surgeriesCount ?? this.surgeriesCount,
      supervisionRequestStatus: supervisionRequestStatus ?? this.supervisionRequestStatus,
    );
  }

  @override
  List<Object?> get props => [
    ...super.props,
    specialization,
    experienceMonths,
    schedules,
    rating,
    reviewsCount,
    recentReviews,
    services,
    bio,
    clinicAddress,
    clinicName,
    languages,
    qualifications,
    education,
    patientsCount,
    surgeriesCount,
    supervisionRequestStatus,
  ];
}

