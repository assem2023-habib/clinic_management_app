import 'package:clinic_management_app/domain/entities/specialization_entity.dart';

class SpecializationModel extends SpecializationEntity {
  const SpecializationModel({
    required super.id,
    required super.slug,
    required super.nameEn,
    required super.nameAr,
    super.description,
  });

  factory SpecializationModel.fromMap(Map<String, dynamic> map) {
    final name = map['name'] as Map<String, dynamic>?;
    return SpecializationModel(
      id: map['id'] as String,
      slug: map['slug'] as String? ?? '',
      nameEn: name?['en'] as String? ?? '',
      nameAr: name?['ar'] as String? ?? '',
      description: map['description'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'slug': slug,
    'name': {'en': nameEn, 'ar': nameAr},
    'description': description,
  };
}
