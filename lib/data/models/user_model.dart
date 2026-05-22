import 'package:clinic_management_app/domain/entities/user_entity.dart';
import 'package:clinic_management_app/data/models/role_model.dart';

class UserModel extends UserEntity {
  const UserModel({
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
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
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
          ? (map['roles'] as List).map((r) => RoleModel.fromMap(r as Map<String, dynamic>)).toList()
          : const [],
      isActive: map['is_active'] as bool? ?? true,
      imageUrl: map['image'] != null && map['image'] is Map
          ? (map['image'] as Map)['url'] as String?
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
    };
  }
}
