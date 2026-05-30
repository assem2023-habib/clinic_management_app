import 'package:clinic_management_app/domain/entities/user_entity.dart';
import 'package:clinic_management_app/domain/entities/role_entity.dart';

class ReceptionistEntity extends UserEntity {
  final String? shiftStart;
  final String? shiftEnd;

  const ReceptionistEntity({
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
    this.shiftStart,
    this.shiftEnd,
  });

  factory ReceptionistEntity.fromUser(UserEntity user, {String? shiftStart, String? shiftEnd}) {
    return ReceptionistEntity(
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
      shiftStart: shiftStart,
      shiftEnd: shiftEnd,
    );
  }

  @override
  ReceptionistEntity copyWith({
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
    String? shiftStart,
    String? shiftEnd,
  }) {
    return ReceptionistEntity(
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
      shiftStart: shiftStart ?? this.shiftStart,
      shiftEnd: shiftEnd ?? this.shiftEnd,
    );
  }

  @override
  List<Object?> get props => [...super.props, shiftStart, shiftEnd];
}
