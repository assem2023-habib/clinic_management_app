import 'package:clinic_management_app/domain/entities/user_entity.dart';

abstract class UserRepository {
  Future<List<UserEntity>> getAllUsers({String? role, String? search, String? gender, bool? isActive});
  Future<UserEntity?> getUserById(String id);
  Future<void> updateUser(String id, Map<String, dynamic> data);
  Future<bool> toggleActive(String id);
  Future<void> deleteUser(String id);
}
