import 'package:equatable/equatable.dart';
import 'package:clinic_management_app/domain/entities/role_entity.dart';

class UserEntity extends Equatable {
  final String id;
  final String firstName;
  final String lastName;
  final String username;
  final String email;
  final String? phone;
  final String? address;
  final String gender;
  final String? birthdayDate;
  final List<RoleEntity> roles;
  final bool isActive;
  final String? imageUrl;

  const UserEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    this.phone,
    this.address,
    required this.gender,
    this.birthdayDate,
    this.roles = const [],
    this.isActive = true,
    this.imageUrl,
  });

  String get fullName => '$firstName $lastName';

  UserEntity copyWith({
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
  }) {
    return UserEntity(
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
    );
  }

  @override
  List<Object?> get props => [id, firstName, lastName, username, email, phone, address, gender, birthdayDate, roles, isActive, imageUrl];
}
