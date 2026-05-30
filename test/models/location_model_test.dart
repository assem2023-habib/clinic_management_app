import 'package:flutter_test/flutter_test.dart';
import 'package:clinic_management_app/data/models/country_model.dart';
import 'package:clinic_management_app/data/models/city_model.dart';

void main() {
  group('CountryModel', () {
    const json = {
      'id': 'sy',
      'name': {'en': 'Syria', 'ar': 'سُورِيَا'},
      'code': 'SY',
      'flag': '🇸🇾',
    };

    test('fromMap creates correct instance', () {
      final model = CountryModel.fromMap(json);
      expect(model.id, 'sy');
      expect(model.nameEn, 'Syria');
      expect(model.nameAr, 'سُورِيَا');
      expect(model.code, 'SY');
      expect(model.flag, '🇸🇾');
    });

    test('toMap produces correct map', () {
      final model = CountryModel.fromMap(json);
      expect(model.toMap(), json);
    });

    test('supports value equality', () {
      final a = CountryModel.fromMap(json);
      final b = CountryModel.fromMap(json);
      expect(a, equals(b));
    });

    test('props contains all fields', () {
      final model = CountryModel.fromMap(json);
      expect(model.props, containsAll(['sy', 'Syria', 'سُورِيَا', 'SY', '🇸🇾']));
    });
  });

  group('CityModel', () {
    const json = {
      'id': 'sy-1',
      'name': {'en': 'Damascus', 'ar': 'دِمَشْقُ'},
      'country_id': 'sy',
    };

    test('fromMap creates correct instance', () {
      final model = CityModel.fromMap(json);
      expect(model.id, 'sy-1');
      expect(model.nameEn, 'Damascus');
      expect(model.nameAr, 'دِمَشْقُ');
      expect(model.countryId, 'sy');
    });

    test('toMap produces correct map', () {
      final model = CityModel.fromMap(json);
      expect(model.toMap(), json);
    });

    test('supports value equality', () {
      final a = CityModel.fromMap(json);
      final b = CityModel.fromMap(json);
      expect(a, equals(b));
    });

    test('props contains all fields', () {
      final model = CityModel.fromMap(json);
      expect(model.props, containsAll(['sy-1', 'Damascus', 'دِمَشْقُ', 'sy']));
    });
  });
}
