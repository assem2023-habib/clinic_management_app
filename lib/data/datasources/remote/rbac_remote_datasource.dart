import 'package:clinic_management_app/core/services/api_service.dart';
import 'package:clinic_management_app/data/models/role_model.dart';
import 'package:clinic_management_app/data/models/permission_model.dart';

class RbacRemoteDataSource {
  final ApiService _api;

  RbacRemoteDataSource(this._api);

  Future<List<RoleModel>> getRoles({int page = 1, int limit = 20, String? search}) async {
    final queryParams = <String, dynamic>{'page': page, 'limit': limit, if (search != null) 'search': search};
    final response = await _api.get('/roles', queryParameters: queryParams);
    final data = response.data['data'] as List<dynamic>? ?? [];
    return data.map((e) => RoleModel.fromMap(e as Map<String, dynamic>)).toList();
  }

  Future<RoleModel> getRoleById(String id) async {
    final response = await _api.get('/roles/$id');
    final data = response.data['data'] as Map<String, dynamic>;
    return RoleModel.fromMap(data);
  }

  Future<RoleModel> createRole(Map<String, dynamic> body) async {
    final response = await _api.post('/roles', data: body);
    final data = response.data['data'] as Map<String, dynamic>;
    return RoleModel.fromMap(data);
  }

  Future<RoleModel> updateRole(String id, Map<String, dynamic> body) async {
    final response = await _api.put('/roles/$id', data: body);
    final data = response.data['data'] as Map<String, dynamic>;
    return RoleModel.fromMap(data);
  }

  Future<void> deleteRole(String id) async {
    await _api.delete('/roles/$id');
  }

  Future<RoleModel> syncPermissions(String roleId, List<String> permissionSlugs) async {
    final response = await _api.post('/roles/$roleId/permissions', data: {'permissions': permissionSlugs});
    final data = response.data['data'] as Map<String, dynamic>;
    return RoleModel.fromMap(data);
  }

  Future<List<PermissionModel>> getPermissions({int page = 1, int limit = 50, String? group, String? search}) async {
    final queryParams = <String, dynamic>{
      'page': page, 'limit': limit,
      if (group != null) 'group': group,
      if (search != null) 'search': search,
    };
    final response = await _api.get('/permissions', queryParameters: queryParams);
    final data = response.data['data'] as List<dynamic>? ?? [];
    return data.map((e) => PermissionModel.fromMap(e as Map<String, dynamic>)).toList();
  }

  Future<PermissionModel> getPermissionById(String id) async {
    final response = await _api.get('/permissions/$id');
    final data = response.data['data'] as Map<String, dynamic>;
    return PermissionModel.fromMap(data);
  }

  Future<PermissionModel> createPermission(Map<String, dynamic> body) async {
    final response = await _api.post('/permissions', data: body);
    final data = response.data['data'] as Map<String, dynamic>;
    return PermissionModel.fromMap(data);
  }

  Future<PermissionModel> updatePermission(String id, Map<String, dynamic> body) async {
    final response = await _api.put('/permissions/$id', data: body);
    final data = response.data['data'] as Map<String, dynamic>;
    return PermissionModel.fromMap(data);
  }

  Future<void> deletePermission(String id) async {
    await _api.delete('/permissions/$id');
  }

  Future<List<RoleModel>> getUserRoles(String userId) async {
    final response = await _api.get('/users/$userId/roles');
    final data = response.data['data'] as List<dynamic>? ?? [];
    return data.map((e) => RoleModel.fromMap(e as Map<String, dynamic>)).toList();
  }

  Future<List<RoleModel>> syncUserRoles(String userId, List<String> roleSlugs) async {
    final response = await _api.post('/users/$userId/roles', data: {'roles': roleSlugs});
    final data = response.data['data'] as List<dynamic>? ?? [];
    return data.map((e) => RoleModel.fromMap(e as Map<String, dynamic>)).toList();
  }
}
