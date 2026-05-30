import 'package:clinic_management_app/domain/entities/country_entity.dart';

class CountryModel extends CountryEntity {
  const CountryModel({
    required super.id,
    required super.nameEn,
    required super.nameAr,
    required super.code,
    super.flag,
    super.createdAt,
    super.updatedAt,
  });

  factory CountryModel.fromMap(Map<String, dynamic> map) {
    final name = map['name'] as Map<String, dynamic>?;
    return CountryModel(
      id: map['id'] as String,
      nameEn: name?['en'] as String? ?? '',
      nameAr: name?['ar'] as String? ?? '',
      code: map['code'] as String,
      flag: map['flag'] as String?,
      createdAt: map['created_at'] as String?,
      updatedAt: map['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': {'en': nameEn, 'ar': nameAr},
    'code': code,
    'flag': flag,
  };
}
