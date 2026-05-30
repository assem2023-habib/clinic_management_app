import 'package:clinic_management_app/data/datasources/remote/user_remote_datasource.dart';
import 'package:clinic_management_app/data/models/user_model.dart';
import 'package:clinic_management_app/domain/entities/user_entity.dart';
import 'package:clinic_management_app/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource? remoteDataSource;

  UserRepositoryImpl({this.remoteDataSource});

  @override
  Future<List<UserEntity>> getAllUsers({String? role, String? search, String? gender, bool? isActive}) async {
    if (remoteDataSource != null) {
      try {
        return await remoteDataSource!.getUsers(role: role, search: search, gender: gender, isActive: isActive);
      } catch (_) {}
    }
    return List.from(_mockUsers);
  }

  @override
  Future<UserEntity?> getUserById(String id) async {
    if (remoteDataSource != null) {
      try {
        return await remoteDataSource!.getUserById(id);
      } catch (_) {}
    }
    try { return _mockUsers.firstWhere((u) => u.id == id); } catch (_) { return null; }
  }

  @override
  Future<void> updateUser(String id, Map<String, dynamic> data) async {
    if (remoteDataSource != null) {
      try {
        await remoteDataSource!.updateUser(id, data);
        return;
      } catch (_) {}
    }
    final i = _mockUsers.indexWhere((u) => u.id == id);
    if (i != -1) {
      _mockUsers[i] = UserModel(
        id: id,
        firstName: data['first_name'] as String? ?? _mockUsers[i].firstName,
        lastName: data['last_name'] as String? ?? _mockUsers[i].lastName,
        username: data['username'] as String? ?? _mockUsers[i].username,
        email: data['email'] as String? ?? _mockUsers[i].email,
        phone: data['phone'] as String? ?? _mockUsers[i].phone,
        address: data['address'] as String? ?? _mockUsers[i].address,
        gender: data['gender'] as String? ?? _mockUsers[i].gender,
        birthdayDate: data['birthday_date'] as String? ?? _mockUsers[i].birthdayDate,
        isActive: _mockUsers[i].isActive,
        roles: _mockUsers[i].roles,
        imageUrl: _mockUsers[i].imageUrl,
        cityId: data['city_id'] as String? ?? _mockUsers[i].cityId,
        createdAt: _mockUsers[i].createdAt,
        updatedAt: _mockUsers[i].updatedAt,
      );
    }
  }

  @override
  Future<bool> toggleActive(String id) async {
    if (remoteDataSource != null) {
      try {
        final result = await remoteDataSource!.toggleActive(id);
        final isActive = (result['data'] as Map<String, dynamic>?)?['is_active'] as bool?;
        return isActive ?? false;
      } catch (_) {}
    }
    final i = _mockUsers.indexWhere((u) => u.id == id);
    if (i != -1) {
      final newActive = !_mockUsers[i].isActive;
      _mockUsers[i] = UserModel(
        id: _mockUsers[i].id, firstName: _mockUsers[i].firstName,
        lastName: _mockUsers[i].lastName, username: _mockUsers[i].username,
        email: _mockUsers[i].email, phone: _mockUsers[i].phone,
        address: _mockUsers[i].address, gender: _mockUsers[i].gender,
        birthdayDate: _mockUsers[i].birthdayDate, isActive: newActive,
        roles: _mockUsers[i].roles, imageUrl: _mockUsers[i].imageUrl,
        cityId: _mockUsers[i].cityId, createdAt: _mockUsers[i].createdAt,
        updatedAt: _mockUsers[i].updatedAt,
      );
      return newActive;
    }
    return false;
  }

  @override
  Future<void> deleteUser(String id) async {
    if (remoteDataSource != null) {
      try { await remoteDataSource!.deleteUser(id); return; } catch (_) {}
    }
    _mockUsers.removeWhere((u) => u.id == id);
  }

  static final List<UserModel> _mockUsers = [];
}
