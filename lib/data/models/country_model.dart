import 'package:clinic_management_app/domain/entities/country_entity.dart';

class CountryModel extends CountryEntity {
  const CountryModel({
    required super.id,
    required super.name,
    required super.nameAr,
    required super.code,
    required super.phoneCode,
    required super.flag,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      nameAr: json['name_ar'] as String,
      code: json['code'] as String,
      phoneCode: json['phone_code'] as String,
      flag: json['flag'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'name_ar': nameAr,
    'code': code,
    'phone_code': phoneCode,
    'flag': flag,
  };
}
