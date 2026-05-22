import 'package:flutter_test/flutter_test.dart';
import 'package:clinic_management_app/data/models/country_model.dart';
import 'package:clinic_management_app/data/models/city_model.dart';

void main() {
  group('CountryModel', () {
    const json = {
      'id': 'sy',
      'name': 'Syria',
      'name_ar': 'سُورِيَا',
      'code': 'SY',
      'phone_code': '+963',
      'flag': '🇸🇾',
    };

    test('fromJson creates correct instance', () {
      final model = CountryModel.fromJson(json);
      expect(model.id, 'sy');
      expect(model.name, 'Syria');
      expect(model.nameAr, 'سُورِيَا');
      expect(model.code, 'SY');
      expect(model.phoneCode, '+963');
      expect(model.flag, '🇸🇾');
    });

    test('toJson produces correct map', () {
      final model = CountryModel.fromJson(json);
      expect(model.toJson(), json);
    });

    test('supports value equality', () {
      final a = CountryModel.fromJson(json);
      final b = CountryModel.fromJson(json);
      expect(a, equals(b));
    });

    test('props contains all fields', () {
      final model = CountryModel.fromJson(json);
      expect(model.props, containsAll(['sy', 'Syria', 'سُورِيَا', 'SY', '+963', '🇸🇾']));
    });
  });

  group('CityModel', () {
    const json = {
      'id': 'sy-1',
      'name': 'Damascus',
      'name_ar': 'دِمَشْقُ',
      'country_id': 'sy',
    };

    test('fromJson creates correct instance', () {
      final model = CityModel.fromJson(json);
      expect(model.id, 'sy-1');
      expect(model.name, 'Damascus');
      expect(model.nameAr, 'دِمَشْقُ');
      expect(model.countryId, 'sy');
    });

    test('toJson produces correct map', () {
      final model = CityModel.fromJson(json);
      expect(model.toJson(), json);
    });

    test('supports value equality', () {
      final a = CityModel.fromJson(json);
      final b = CityModel.fromJson(json);
      expect(a, equals(b));
    });

    test('props contains all fields', () {
      final model = CityModel.fromJson(json);
      expect(model.props, containsAll(['sy-1', 'Damascus', 'دِمَشْقُ', 'sy']));
    });
  });
}
