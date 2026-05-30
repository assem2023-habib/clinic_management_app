import 'package:clinic_management_app/domain/entities/specialization_entity.dart';

class SpecializationModel extends SpecializationEntity {
  const SpecializationModel({
    required super.id,
    required super.slug,
    required super.name,
    super.description,
    super.isActive = true,
    super.doctorsCount = 0,
    super.imageUrl,
    super.createdAt,
    super.updatedAt,
  });

  factory SpecializationModel.fromMap(Map<String, dynamic> map) {
    final image = map['image'];
    return SpecializationModel(
      id: map['id'] as String,
      slug: map['slug'] as String? ?? '',
      name: map['name'] != null
          ? Map<String, String>.from((map['name'] as Map).map((k, v) => MapEntry(k, v as String)))
          : {'en': '', 'ar': ''},
      description: map['description'] != null && map['description'] is Map
          ? Map<String, String>.from((map['description'] as Map).map((k, v) => MapEntry(k, v as String)))
          : null,
      isActive: map['is_active'] as bool? ?? true,
      doctorsCount: map['doctors_count'] as int? ?? 0,
      imageUrl: image is Map ? (image)['url'] as String? : null,
      createdAt: map['created_at'] as String?,
      updatedAt: map['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'slug': slug,
    'name': name,
    if (description != null) 'description': description,
    'is_active': isActive,
  };
}
