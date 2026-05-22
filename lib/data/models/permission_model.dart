import 'package:clinic_management_app/domain/entities/permission_entity.dart';

class PermissionModel extends PermissionEntity {
  const PermissionModel({
    required super.id,
    required super.name,
    required super.slug,
    super.description,
    super.group,
    super.guardName = 'api',
  });

  factory PermissionModel.fromMap(Map<String, dynamic> map) {
    return PermissionModel(
      id: map['id'] as String,
      name: map['name'] as String? ?? '',
      slug: map['slug'] as String? ?? '',
      description: map['description'] as String?,
      group: map['group'] as String?,
      guardName: map['guard_name'] as String? ?? 'api',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'description': description,
      'group': group,
      'guard_name': guardName,
    };
  }
}
