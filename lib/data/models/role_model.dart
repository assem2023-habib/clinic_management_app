import 'package:clinic_management_app/domain/entities/role_entity.dart';
import 'package:clinic_management_app/data/models/permission_model.dart';

class RoleModel extends RoleEntity {
  const RoleModel({
    required super.id,
    required super.name,
    required super.slug,
    super.description,
    super.guardName = 'api',
    super.isSystem = false,
    super.permissions = const [],
    super.usersCount = 0,
  });

  factory RoleModel.fromMap(Map<String, dynamic> map) {
    return RoleModel(
      id: map['id'] as String,
      name: map['name'] as String? ?? '',
      slug: map['slug'] as String? ?? '',
      description: map['description'] as String?,
      guardName: map['guard_name'] as String? ?? 'api',
      isSystem: map['is_system'] as bool? ?? false,
      permissions: map['permissions'] != null
          ? (map['permissions'] as List).map((p) => PermissionModel.fromMap(p as Map<String, dynamic>)).toList()
          : const [],
      usersCount: map['users_count'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'description': description,
      'guard_name': guardName,
      'is_system': isSystem,
      'permissions': permissions.map((p) => (p as PermissionModel).toMap()).toList(),
      'users_count': usersCount,
    };
  }
}
