import 'package:flutter_test/flutter_test.dart';
import 'package:clinic_management_app/domain/entities/country_entity.dart';
import 'package:clinic_management_app/domain/entities/city_entity.dart';

void main() {
  group('CountryEntity', () {
    const entity = CountryEntity(
      id: 'sa',
      nameEn: 'Saudi Arabia',
      nameAr: 'السُّعُودِيَّةُ',
      code: 'SA',
      flag: '🇸🇦',
    );

    test('supports value equality', () {
      const same = CountryEntity(
        id: 'sa',
        nameEn: 'Saudi Arabia',
        nameAr: 'السُّعُودِيَّةُ',
        code: 'SA',
        flag: '🇸🇦',
      );
      expect(entity, equals(same));
    });

    test('not equal when id differs', () {
      const other = CountryEntity(
        id: 'eg',
        nameEn: 'Egypt',
        nameAr: 'مِصْرُ',
        code: 'EG',
        flag: '🇪🇬',
      );
      expect(entity, isNot(equals(other)));
    });

    test('props contains all fields', () {
      expect(entity.props, containsAll(['sa', 'Saudi Arabia', 'السُّعُودِيَّةُ', 'SA', '🇸🇦']));
    });
  });

  group('CityEntity', () {
    const entity = CityEntity(
      id: 'sa-1',
      nameEn: 'Riyadh',
      nameAr: 'الرِّيَاضُ',
      countryId: 'sa',
    );

    test('supports value equality', () {
      const same = CityEntity(
        id: 'sa-1',
        nameEn: 'Riyadh',
        nameAr: 'الرِّيَاضُ',
        countryId: 'sa',
      );
      expect(entity, equals(same));
    });

    test('not equal when id differs', () {
      const other = CityEntity(
        id: 'sa-2',
        nameEn: 'Jeddah',
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
