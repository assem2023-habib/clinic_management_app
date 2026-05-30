import 'package:clinic_management_app/domain/entities/receptionist_entity.dart';
import 'package:clinic_management_app/data/models/role_model.dart';

class ReceptionistModel extends ReceptionistEntity {
  const ReceptionistModel({
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
    super.shiftStart,
    super.shiftEnd,
  });

  factory ReceptionistModel.fromMap(Map<String, dynamic> map) {
    List<String>? fcmTokens;
    if (map['fcm_tokens'] != null) {
      if (map['fcm_tokens'] is List) {
        fcmTokens = (map['fcm_tokens'] as List).cast<String>();
      }
    }
    return ReceptionistModel(
      id: map['id'] as String,
      firstName: map['first_name'] as String? ?? '',
      lastName: map['last_name'] as String? ?? '',
      username: map['username'] as String? ?? '',
      email: map['email'] as String? ?? '',
      phone: map['phone'] as String?,
      address: map['address'] as String?,
      gender: map['gender'] as String? ?? 'male',
      birthdayDate: map['birthday_date'] as String?,
      roles: map['roles'] != null
          ? (map['roles'] as List).map((r) => RoleModel.fromDynamic(r)).toList()
          : const [],
      isActive: map['is_active'] as bool? ?? true,
      imageUrl: map['image'] != null && map['image'] is Map
          ? (map['image'] as Map)['url'] as String?
          : null,
      countryId: map['country_id'] as String?,
      cityId: map['city_id'] as String?,
      fcmTokens: fcmTokens,
      emailVerifiedAt: map['email_verified_at'] as String?,
      createdAt: map['created_at'] as String?,
      updatedAt: map['updated_at'] as String?,
      shiftStart: map['receptionist'] != null && map['receptionist'] is Map
          ? (map['receptionist'] as Map)['shift_start'] as String?
          : null,
      shiftEnd: map['receptionist'] != null && map['receptionist'] is Map
          ? (map['receptionist'] as Map)['shift_end'] as String?
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'username': username,
      'email': email,
      'phone': phone,
      'address': address,
      'gender': gender,
      'birthday_date': birthdayDate,
      'roles': roles.map((r) => (r as RoleModel).toMap()).toList(),
      'is_active': isActive,
      'country_id': countryId,
      'city_id': cityId,
      'fcm_tokens': fcmTokens,
      'email_verified_at': emailVerifiedAt,
      'shift_start': shiftStart,
      'shift_end': shiftEnd,
    };
  }
}
