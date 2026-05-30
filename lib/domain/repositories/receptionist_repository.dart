import 'package:clinic_management_app/domain/entities/receptionist_entity.dart';

abstract class ReceptionistRepository {
  Future<List<ReceptionistEntity>> getAllReceptionists({String? search, String? gender, bool? isActive});
  Future<ReceptionistEntity?> getReceptionistById(String id);
  Future<ReceptionistEntity> createReceptionist(ReceptionistEntity receptionist);
  Future<void> updateReceptionist(ReceptionistEntity receptionist);
  Future<void> deleteReceptionist(String id);
  Future<bool> activateAccount(String id);
}
