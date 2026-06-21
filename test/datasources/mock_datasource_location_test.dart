import 'package:flutter_test/flutter_test.dart';
import 'package:clinic_management_app/data/datasources/local/mock_datasource.dart';

void main() {
  late MockDataSource dataSource;

  setUp(() {
    dataSource = MockDataSource();
  });

  group('MockDataSource - Location', () {
    test('allCountries returns 22 countries', () {
      final countries = dataSource.allCountries;
      expect(countries.length, 22);
      expect(countries.first.nameAr, 'سُورِيَا');
      expect(countries.last.nameEn, 'Comoros');
    });

    test('allCities returns 41 cities', () {
      final cities = dataSource.allCities;
      expect(cities.length, 41);
    });

    test('citiesByCountry filters correctly', () {
      final syrianCities = dataSource.citiesByCountry('sy');
      expect(syrianCities.length, 4);

      final egyptCities = dataSource.citiesByCountry('eg');
      expect(egyptCities.length, 3);

      final saudiCities = dataSource.citiesByCountry('sa');
      expect(saudiCities.length, 5);
    });

    test('citiesByCountry returns empty for unknown country', () {
      final cities = dataSource.citiesByCountry('xx');
      expect(cities, isEmpty);
    });

    test('searchCities finds by Arabic name', () {
      final result = dataSource.searchCities('دِمَشْ', countryId: 'sy');
      expect(result.length, 1);
      expect(result.first.nameAr, 'دِمَشْقُ');
    });

    test('searchCities finds by English name', () {
      final result = dataSource.searchCities('Cairo');
      expect(result.length, 1);
      expect(result.first.nameEn, 'Cairo');
    });

    test('searchCities without countryId searches all countries', () {
      final result = dataSource.searchCities('Da');
      expect(result.length, 4);
    });

    test('searchCities returns empty for no match', () {
      final result = dataSource.searchCities('Xyzzy');
      expect(result, isEmpty);
    });

    test('allCountries list is unmodifiable', () {
      expect(() => dataSource.allCountries.add(dataSource.allCountries.first), throwsA(anything));
    });

    test('allCities list is unmodifiable', () {
      expect(() => dataSource.allCities.add(dataSource.allCities.first), throwsA(anything));
    });
  });
}
