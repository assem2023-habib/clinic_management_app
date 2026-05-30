import 'package:clinic_management_app/domain/entities/specialization_entity.dart';

abstract class SpecializationRepository {
  Future<List<SpecializationEntity>> getAllSpecializations({String? search, String? slug, bool? isActive});
  Future<SpecializationEntity?> getSpecializationById(String id);
  Future<SpecializationEntity> createSpecialization(SpecializationEntity specialization);
  Future<void> updateSpecialization(SpecializationEntity specialization);
  Future<void> deleteSpecialization(String id);
}
