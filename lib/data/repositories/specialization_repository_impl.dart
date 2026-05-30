import 'package:clinic_management_app/data/datasources/remote/doctor_remote_datasource.dart';
import 'package:clinic_management_app/data/models/specialization_model.dart';
import 'package:clinic_management_app/domain/entities/specialization_entity.dart';
import 'package:clinic_management_app/domain/repositories/specialization_repository.dart';

class SpecializationRepositoryImpl implements SpecializationRepository {
  final DoctorRemoteDataSource? remoteDataSource;

  SpecializationRepositoryImpl({this.remoteDataSource});

  @override
  Future<List<SpecializationEntity>> getAllSpecializations({String? search, String? slug, bool? isActive}) async {
    if (remoteDataSource != null) {
      try {
        return await remoteDataSource!.getSpecializations(search: search, slug: slug, isActive: isActive);
      } catch (_) {}
    }
    return List.from(_mockSpecs);
  }

  @override
  Future<SpecializationEntity?> getSpecializationById(String id) async {
    if (remoteDataSource != null) {
      try {
        return await remoteDataSource!.getSpecializationById(id);
      } catch (_) {}
    }
    try { return _mockSpecs.firstWhere((s) => s.id == id); } catch (_) { return null; }
  }

  @override
  Future<SpecializationEntity> createSpecialization(SpecializationEntity specialization) async {
    if (remoteDataSource != null) {
      try {
        return await remoteDataSource!.createSpecialization({
          'slug': specialization.slug,
          'name': specialization.name,
          'description': specialization.description,
          'is_active': specialization.isActive,
        });
      } catch (_) {}
    }
    final model = SpecializationModel(
      id: specialization.id, slug: specialization.slug, name: specialization.name,
      description: specialization.description, isActive: specialization.isActive,
      doctorsCount: specialization.doctorsCount, imageUrl: specialization.imageUrl,
    );
    _mockSpecs.add(model);
    return model;
  }

  @override
  Future<void> updateSpecialization(SpecializationEntity specialization) async {
    if (remoteDataSource != null) {
      try {
        await remoteDataSource!.updateSpecialization(specialization.id, {
          'slug': specialization.slug,
          'name': specialization.name,
          'description': specialization.description,
          'is_active': specialization.isActive,
        });
        return;
      } catch (_) {}
    }
    final i = _mockSpecs.indexWhere((s) => s.id == specialization.id);
    if (i != -1) {
      _mockSpecs[i] = SpecializationModel(
        id: specialization.id, slug: specialization.slug, name: specialization.name,
        description: specialization.description, isActive: specialization.isActive,
        doctorsCount: specialization.doctorsCount, imageUrl: specialization.imageUrl,
      );
    }
  }

  @override
  Future<void> deleteSpecialization(String id) async {
    if (remoteDataSource != null) {
      try { await remoteDataSource!.deleteSpecialization(id); return; } catch (_) {}
    }
    _mockSpecs.removeWhere((s) => s.id == id);
  }

  static final List<SpecializationModel> _mockSpecs = [];
}
