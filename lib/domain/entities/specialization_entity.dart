import 'package:equatable/equatable.dart';

class SpecializationEntity extends Equatable {
  final String id;
  final String slug;
  final String nameEn;
  final String nameAr;
  final String? descriptionEn;
  final String? descriptionAr;
  final bool isActive;
  final int doctorsCount;
  final String? imageUrl;
  final String? createdAt;
  final String? updatedAt;

  const SpecializationEntity({
    required this.id,
    required this.slug,
    required this.nameEn,
    required this.nameAr,
    this.descriptionEn,
    this.descriptionAr,
    this.isActive = true,
    this.doctorsCount = 0,
    this.imageUrl,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id, slug, nameEn, nameAr, descriptionEn, descriptionAr,
    isActive, doctorsCount, imageUrl, createdAt, updatedAt,
  ];
}
