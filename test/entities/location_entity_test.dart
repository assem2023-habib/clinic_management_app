import 'package:flutter_test/flutter_test.dart';
import 'package:clinic_management_app/domain/entities/country_entity.dart';
import 'package:clinic_management_app/domain/entities/city_entity.dart';

void main() {
  group('CountryEntity', () {
    const entity = CountryEntity(
      id: 'sa',
      name: 'Saudi Arabia',
      nameAr: 'السُّعُودِيَّةُ',
      code: 'SA',
      phoneCode: '+966',
      flag: '🇸🇦',
    );

    test('supports value equality', () {
      const same = CountryEntity(
        id: 'sa',
        name: 'Saudi Arabia',
        nameAr: 'السُّعُودِيَّةُ',
        code: 'SA',
        phoneCode: '+966',
        flag: '🇸🇦',
      );
      expect(entity, equals(same));
    });

    test('not equal when id differs', () {
      const other = CountryEntity(
        id: 'eg',
        name: 'Egypt',
        nameAr: 'مِصْرُ',
        code: 'EG',
        phoneCode: '+20',
        flag: '🇪🇬',
      );
      expect(entity, isNot(equals(other)));
    });

    test('props contains all fields', () {
      expect(entity.props, containsAll(['sa', 'Saudi Arabia', 'السُّعُودِيَّةُ', 'SA', '+966', '🇸🇦']));
    });
  });

  group('CityEntity', () {
    const entity = CityEntity(
      id: 'sa-1',
      name: 'Riyadh',
      nameAr: 'الرِّيَاضُ',
      countryId: 'sa',
    );

    test('supports value equality', () {
      const same = CityEntity(
        id: 'sa-1',
        name: 'Riyadh',
        nameAr: 'الرِّيَاضُ',
        countryId: 'sa',
      );
      expect(entity, equals(same));
    });

    test('not equal when id differs', () {
      const other = CityEntity(
        id: 'sa-2',
        name: 'Jeddah',
        nameAr: 'جِدَّةُ',
        countryId: 'sa',
      );
      expect(entity, isNot(equals(other)));
    });

    test('props contains all fields', () {
      expect(entity.props, containsAll(['sa-1', 'Riyadh', 'الرِّيَاضُ', 'sa']));
    });
  });
}
