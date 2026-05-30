import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:clinic_management_app/data/datasources/data_source.dart';
import 'package:clinic_management_app/data/models/country_model.dart';
import 'package:clinic_management_app/data/models/city_model.dart';
import 'package:clinic_management_app/data/repositories/location_repository_impl.dart';

class MockDataSource extends Mock implements DataSource {}

void main() {
  late MockDataSource dataSource;
  late LocationRepositoryImpl repository;

  final countries = <CountryModel>[
    const CountryModel(id: 'sy', nameEn: 'Syria', nameAr: 'سُورِيَا', code: 'SY', flag: '🇸🇾'),
    const CountryModel(id: 'eg', nameEn: 'Egypt', nameAr: 'مِصْرُ', code: 'EG', flag: '🇪🇬'),
  ];

  final cities = <CityModel>[
    const CityModel(id: 'sy-1', nameEn: 'Damascus', nameAr: 'دِمَشْقُ', countryId: 'sy'),
    const CityModel(id: 'sy-2', nameEn: 'Aleppo', nameAr: 'حَلَبُ', countryId: 'sy'),
    const CityModel(id: 'eg-1', nameEn: 'Cairo', nameAr: 'القَاهِرَةُ', countryId: 'eg'),
  ];

  setUp(() {
    dataSource = MockDataSource();
    repository = LocationRepositoryImpl(dataSource);
  });

  group('getAllCountries', () {
    test('returns all countries from data source', () async {
      when(() => dataSource.allCountries).thenReturn(countries);
      final result = await repository.getAllCountries();
      expect(result, equals(countries));
      expect(result.length, 2);
    });
  });

  group('getCitiesByCountry', () {
    test('returns cities filtered by country id', () async {
      when(() => dataSource.citiesByCountry('sy')).thenReturn([cities[0], cities[1]]);
      final result = await repository.getCitiesByCountry('sy');
      expect(result.length, 2);
      expect(result[0].countryId, 'sy');
    });

    test('returns empty list for country with no cities', () async {
      when(() => dataSource.citiesByCountry('xx')).thenReturn([]);
      final result = await repository.getCitiesByCountry('xx');
      expect(result, isEmpty);
    });
  });

  group('searchCities', () {
    test('delegates to data source with query and optional countryId', () async {
      when(() => dataSource.searchCities('دمشق', countryId: any(named: 'countryId'))).thenReturn([cities[0]]);
      final result = await repository.searchCities('دمشق', countryId: 'sy');
      expect(result.length, 1);
      expect(result[0].nameAr, 'دِمَشْقُ');
    });

    test('delegates to data source without countryId', () async {
      when(() => dataSource.searchCities('Da', countryId: any(named: 'countryId'))).thenReturn([cities[0]]);
      final result = await repository.searchCities('Da');
      expect(result.length, 1);
    });
  });
}
