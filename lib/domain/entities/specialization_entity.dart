import 'package:equatable/equatable.dart';

class SpecializationEntity extends Equatable {
  final String id;
  final String slug;
  final Map<String, String> name;
  final Map<String, String>? description;
  final bool isActive;
  final int doctorsCount;
  final String? imageUrl;
  final String? createdAt;
  final String? updatedAt;

  const SpecializationEntity({
    required this.id,
    required this.slug,
    required this.name,
    this.description,
    this.isActive = true,
    this.doctorsCount = 0,
    this.imageUrl,
    this.createdAt,
    this.updatedAt,
  });

  String get nameEn => name['en'] ?? '';
  String get nameAr => name['ar'] ?? '';
  String get descriptionEn => description?['en'];
  String get descriptionAr => description?['ar'];

  @override
  List<Object?> get props => [
    id, slug, name, description, isActive, doctorsCount,
    imageUrl, createdAt, updatedAt,
  ];
}
