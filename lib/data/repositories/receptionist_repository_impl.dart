import 'package:clinic_management_app/data/datasources/remote/receptionist_remote_datasource.dart';
import 'package:clinic_management_app/data/models/receptionist_model.dart';
import 'package:clinic_management_app/domain/entities/receptionist_entity.dart';
import 'package:clinic_management_app/domain/repositories/receptionist_repository.dart';

class ReceptionistRepositoryImpl implements ReceptionistRepository {
  final ReceptionistRemoteDataSource? remoteDataSource;

  ReceptionistRepositoryImpl({this.remoteDataSource});

  @override
  Future<List<ReceptionistEntity>> getAllReceptionists({String? search, String? gender, bool? isActive}) async {
    if (remoteDataSource != null) {
      try {
        return await remoteDataSource!.getReceptionists(search: search, gender: gender, isActive: isActive);
      } catch (_) {}
    }
    return List.from(_mockRecs);
  }

  @override
  Future<ReceptionistEntity?> getReceptionistById(String id) async {
    if (remoteDataSource != null) {
      try { return await remoteDataSource!.getReceptionistById(id); } catch (_) {}
    }
    try { return _mockRecs.firstWhere((r) => r.id == id); } catch (_) { return null; }
  }

  @override
  Future<ReceptionistEntity> createReceptionist(ReceptionistEntity rec) async {
    if (remoteDataSource != null) {
      try {
        return await remoteDataSource!.createReceptionist({
          'first_name': rec.firstName, 'last_name': rec.lastName,
          'username': rec.username, 'email': rec.email,
          'phone': rec.phone, 'address': rec.address,
          'gender': rec.gender, 'birthday_date': rec.birthdayDate,
          'shift_start': rec.shiftStart, 'shift_end': rec.shiftEnd,
        });
      } catch (_) {}
    }
    final model = ReceptionistModel(
      id: rec.id, firstName: rec.firstName, lastName: rec.lastName,
      username: rec.username, email: rec.email, phone: rec.phone,
      address: rec.address, gender: rec.gender, birthdayDate: rec.birthdayDate,
      roles: rec.roles, isActive: rec.isActive, imageUrl: rec.imageUrl,
      shiftStart: rec.shiftStart, shiftEnd: rec.shiftEnd,
    );
    _mockRecs.add(model);
    return model;
  }

  @override
  Future<void> updateReceptionist(ReceptionistEntity rec) async {
    if (remoteDataSource != null) {
      try {
        await remoteDataSource!.updateReceptionist(rec.id, {
          'first_name': rec.firstName, 'last_name': rec.lastName,
          'username': rec.username, 'email': rec.email,
          'phone': rec.phone, 'address': rec.address,
          'gender': rec.gender, 'birthday_date': rec.birthdayDate,
          'shift_start': rec.shiftStart, 'shift_end': rec.shiftEnd,
        });
        return;
      } catch (_) {}
    }
    final i = _mockRecs.indexWhere((r) => r.id == rec.id);
    if (i != -1) {
      _mockRecs[i] = ReceptionistModel(
        id: rec.id, firstName: rec.firstName, lastName: rec.lastName,
        username: rec.username, email: rec.email, phone: rec.phone,
        address: rec.address, gender: rec.gender, birthdayDate: rec.birthdayDate,
        roles: rec.roles, isActive: rec.isActive, imageUrl: rec.imageUrl,
        shiftStart: rec.shiftStart, shiftEnd: rec.shiftEnd,
      );
    }
  }

  @override
  Future<void> deleteReceptionist(String id) async {
    if (remoteDataSource != null) {
      try { await remoteDataSource!.deleteReceptionist(id); return; } catch (_) {}
    }
    _mockRecs.removeWhere((r) => r.id == id);
  }

  @override
  Future<bool> activateAccount(String id) async {
    if (remoteDataSource != null) {
      try { await remoteDataSource!.activateAccount(id); return true; } catch (_) {}
    }
    return false;
  }

  static final List<ReceptionistModel> _mockRecs = [];
}
