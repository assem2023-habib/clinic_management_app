import 'package:clinic_management_app/data/datasources/remote/rbac_remote_datasource.dart';
import 'package:clinic_management_app/data/models/role_model.dart';
import 'package:clinic_management_app/data/models/permission_model.dart';
import 'package:clinic_management_app/domain/entities/role_entity.dart';
import 'package:clinic_management_app/domain/entities/permission_entity.dart';
import 'package:clinic_management_app/domain/repositories/rbac_repository.dart';

class RbacRepositoryImpl implements RbacRepository {
  final RbacRemoteDataSource? remoteDataSource;

  RbacRepositoryImpl({this.remoteDataSource});

  @override
  Future<List<RoleEntity>> getRoles({String? search}) async {
    if (remoteDataSource != null) {
      try {
        return await remoteDataSource!.getRoles(search: search);
      } catch (_) {}
    }
    return List.from(_mockRoles);
  }

  @override
  Future<RoleEntity?> getRoleById(String id) async {
    if (remoteDataSource != null) {
      try {
        return await remoteDataSource!.getRoleById(id);
      } catch (_) {}
    }
    try { return _mockRoles.firstWhere((r) => r.id == id); } catch (_) { return null; }
  }

  @override
  Future<RoleEntity> createRole(RoleEntity role) async {
    if (remoteDataSource != null) {
      try {
        return await remoteDataSource!.createRole({
          'name': role.name,
          'slug': role.slug,
          'description': role.description,
          'permissions': role.permissions.map((p) => p.slug).toList(),
        });
      } catch (_) {}
    }
    final model = RoleModel(id: role.id, name: role.name, slug: role.slug,
        description: role.description, isSystem: role.isSystem,
        permissions: role.permissions, usersCount: role.usersCount);
    _mockRoles.add(model);
    return model;
  }

  @override
  Future<void> updateRole(RoleEntity role) async {
    if (remoteDataSource != null) {
      try {
        await remoteDataSource!.updateRole(role.id, {
          'name': role.name,
          'slug': role.slug,
          'description': role.description,
        });
        return;
      } catch (_) {}
    }
    final i = _mockRoles.indexWhere((r) => r.id == role.id);
    if (i != -1) {
      _mockRoles[i] = RoleModel(id: role.id, name: role.name, slug: role.slug,
          description: role.description, isSystem: role.isSystem,
          permissions: role.permissions, usersCount: role.usersCount);
    }
  }

  @override
  Future<void> deleteRole(String id) async {
    if (remoteDataSource != null) {
      try { await remoteDataSource!.deleteRole(id); return; } catch (_) {}
    }
    _mockRoles.removeWhere((r) => r.id == id);
  }

  @override
  Future<RoleEntity> syncPermissions(String roleId, List<String> permissionSlugs) async {
    if (remoteDataSource != null) {
      try {
        return await remoteDataSource!.syncPermissions(roleId, permissionSlugs);
      } catch (_) {}
    }
    final i = _mockRoles.indexWhere((r) => r.id == roleId);
    if (i != -1) return _mockRoles[i];
    throw Exception('Role not found');
  }

  @override
  Future<List<PermissionEntity>> getPermissions({String? group, String? search}) async {
    if (remoteDataSource != null) {
      try {
        return await remoteDataSource!.getPermissions(group: group, search: search);
      } catch (_) {}
    }
    return List.from(_mockPermissions);
  }

  @override
  Future<PermissionEntity?> getPermissionById(String id) async {
    if (remoteDataSource != null) {
      try {
        return await remoteDataSource!.getPermissionById(id);
      } catch (_) {}
    }
    try { return _mockPermissions.firstWhere((p) => p.id == id); } catch (_) { return null; }
  }

  @override
  Future<PermissionEntity> createPermission(PermissionEntity permission) async {
    if (remoteDataSource != null) {
      try {
        return await remoteDataSource!.createPermission({
          'name': permission.name,
          'slug': permission.slug,
          'description': permission.description,
          'group': permission.group,
        });
      } catch (_) {}
    }
    final model = PermissionModel(id: permission.id, name: permission.name,
        slug: permission.slug, description: permission.description,
        group: permission.group, guardName: permission.guardName);
    _mockPermissions.add(model);
    return model;
  }

  @override
  Future<void> updatePermission(PermissionEntity permission) async {
    if (remoteDataSource != null) {
      try {
        await remoteDataSource!.updatePermission(permission.id, {
          'name': permission.name,
          'slug': permission.slug,
          'description': permission.description,
          'group': permission.group,
        });
        return;
      } catch (_) {}
    }
    final i = _mockPermissions.indexWhere((p) => p.id == permission.id);
    if (i != -1) {
      _mockPermissions[i] = PermissionModel(id: permission.id, name: permission.name,
          slug: permission.slug, description: permission.description,
          group: permission.group, guardName: permission.guardName);
    }
  }

  @override
  Future<void> deletePermission(String id) async {
    if (remoteDataSource != null) {
      try { await remoteDataSource!.deletePermission(id); return; } catch (_) {}
    }
    _mockPermissions.removeWhere((p) => p.id == id);
  }

  @override
  Future<List<RoleEntity>> getUserRoles(String userId) async {
    if (remoteDataSource != null) {
      try {
        return await remoteDataSource!.getUserRoles(userId);
      } catch (_) {}
    }
    return List.from(_mockRoles);
  }

  @override
  Future<List<RoleEntity>> syncUserRoles(String userId, List<String> roleSlugs) async {
    if (remoteDataSource != null) {
      try {
        return await remoteDataSource!.syncUserRoles(userId, roleSlugs);
      } catch (_) {}
    }
    return List.from(_mockRoles);
  }

  static final List<RoleModel> _mockRoles = [];
  static final List<PermissionModel> _mockPermissions = [];
}
