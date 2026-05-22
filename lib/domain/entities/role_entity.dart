import 'package:equatable/equatable.dart';
import 'package:clinic_management_app/domain/entities/permission_entity.dart';

class RoleEntity extends Equatable {
  final String id;
  final String name;
  final String slug;
  final String? description;
  final String guardName;
  final bool isSystem;
  final List<PermissionEntity> permissions;
  final int usersCount;

  const RoleEntity({
    required this.id,
    required this.name,
    required this.slug,
    this.description,
    this.guardName = 'api',
    this.isSystem = false,
    this.permissions = const [],
    this.usersCount = 0,
  });

  RoleEntity copyWith({
    String? id,
    String? name,
    String? slug,
    String? description,
    String? guardName,
    bool? isSystem,
    List<PermissionEntity>? permissions,
    int? usersCount,
  }) {
    return RoleEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      description: description ?? this.description,
      guardName: guardName ?? this.guardName,
      isSystem: isSystem ?? this.isSystem,
      permissions: permissions ?? this.permissions,
      usersCount: usersCount ?? this.usersCount,
    );
  }

  @override
  List<Object?> get props => [id, name, slug, description, guardName, isSystem, permissions, usersCount];
}
