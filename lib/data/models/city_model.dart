import 'package:clinic_management_app/domain/entities/city_entity.dart';

class CityModel extends CityEntity {
  const CityModel({
    required super.id,
    required super.nameEn,
    required super.nameAr,
    required super.countryId,
    super.createdAt,
    super.updatedAt,
  });

  factory CityModel.fromMap(Map<String, dynamic> map) {
    final name = map['name'] as Map<String, dynamic>?;
    return CityModel(
      id: map['id'] as String,
      nameEn: name?['en'] as String? ?? '',
      nameAr: name?['ar'] as String? ?? '',
      countryId: map['country_id'] as String,
      createdAt: map['created_at'] as String?,
      updatedAt: map['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': {'en': nameEn, 'ar': nameAr},
    'country_id': countryId,
  };
}
