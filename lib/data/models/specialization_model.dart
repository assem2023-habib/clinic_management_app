import 'package:clinic_management_app/domain/entities/specialization_entity.dart';

class SpecializationModel extends SpecializationEntity {
  const SpecializationModel({
    required super.id,
    required super.slug,
    required super.nameEn,
    required super.nameAr,
    super.descriptionEn,
    super.descriptionAr,
    super.isActive = true,
    super.doctorsCount = 0,
    super.imageUrl,
    super.createdAt,
    super.updatedAt,
  });

  factory SpecializationModel.fromMap(Map<String, dynamic> map) {
    final name = map['name'] as Map<String, dynamic>?;
    final description = map['description'] as Map<String, dynamic>?;
    final image = map['image'];
    return SpecializationModel(
      id: map['id'] as String,
      slug: map['slug'] as String? ?? '',
      nameEn: name?['en'] as String? ?? '',
      nameAr: name?['ar'] as String? ?? '',
      descriptionEn: description?['en'] as String?,
      descriptionAr: description?['ar'] as String?,
      isActive: map['is_active'] as bool? ?? true,
      doctorsCount: map['doctors_count'] as int? ?? 0,
      imageUrl: image is Map
          ? (image)['url'] as String?
          : null,
      createdAt: map['created_at'] as String?,
      updatedAt: map['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'slug': slug,
    'name': {'en': nameEn, 'ar': nameAr},
    if (descriptionEn != null || descriptionAr != null)
      'description': {'en': descriptionEn, 'ar': descriptionAr},
    'is_active': isActive,
  };
}
