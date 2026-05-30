import 'package:clinic_management_app/domain/entities/role_entity.dart';
import 'package:clinic_management_app/domain/entities/permission_entity.dart';

abstract class RbacRepository {
  Future<List<RoleEntity>> getRoles({String? search});
  Future<RoleEntity?> getRoleById(String id);
  Future<RoleEntity> createRole(RoleEntity role);
  Future<void> updateRole(RoleEntity role);
  Future<void> deleteRole(String id);
  Future<RoleEntity> syncPermissions(String roleId, List<String> permissionSlugs);

  Future<List<PermissionEntity>> getPermissions({String? group, String? search});
  Future<PermissionEntity?> getPermissionById(String id);
  Future<PermissionEntity> createPermission(PermissionEntity permission);
  Future<void> updatePermission(PermissionEntity permission);
  Future<void> deletePermission(String id);

  Future<List<RoleEntity>> getUserRoles(String userId);
  Future<List<RoleEntity>> syncUserRoles(String userId, List<String> roleSlugs);
}
