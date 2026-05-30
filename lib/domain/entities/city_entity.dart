import 'package:equatable/equatable.dart';

class CityEntity extends Equatable {
  final String id;
  final String nameEn;
  final String nameAr;
  final String countryId;
  final String? createdAt;
  final String? updatedAt;

  const CityEntity({
    required this.id,
    required this.nameEn,
    required this.nameAr,
    required this.countryId,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [id, nameEn, nameAr, countryId, createdAt, updatedAt];
}
