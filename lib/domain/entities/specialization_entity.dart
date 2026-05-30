import 'package:equatable/equatable.dart';

class SpecializationEntity extends Equatable {
  final String id;
  final String slug;
  final String nameEn;
  final String nameAr;
  final String? description;

  const SpecializationEntity({
    required this.id,
    required this.slug,
    required this.nameEn,
    required this.nameAr,
    this.description,
  });

  @override
  List<Object?> get props => [id, slug, nameEn, nameAr, description];
}
