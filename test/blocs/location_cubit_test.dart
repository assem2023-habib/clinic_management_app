import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:clinic_management_app/domain/entities/country_entity.dart';
import 'package:clinic_management_app/domain/entities/city_entity.dart';
import 'package:clinic_management_app/domain/repositories/location_repository.dart';
import 'package:clinic_management_app/presentation/blocs/location/location_cubit.dart';

class MockLocationRepository extends Mock implements LocationRepository {}

void main() {
  late MockLocationRepository repository;
  late LocationCubit cubit;

  final testCountries = <CountryEntity>[
    CountryEntity(id: 'sy', nameEn: 'Syria', nameAr: 'سُورِيَا', code: 'SY', flag: '🇸🇾'),
    CountryEntity(id: 'eg', nameEn: 'Egypt', nameAr: 'مِصْرُ', code: 'EG', flag: '🇪🇬'),
  ];

  final testCities = <CityEntity>[
    CityEntity(id: 'sy-1', nameEn: 'Damascus', nameAr: 'دِمَشْقُ', countryId: 'sy'),
    CityEntity(id: 'sy-2', nameEn: 'Aleppo', nameAr: 'حَلَبُ', countryId: 'sy'),
  ];

  setUp(() {
    repository = MockLocationRepository();
    cubit = LocationCubit(locationRepository: repository);
  });

  tearDown(() {
    cubit.close();
  });

  group('initial state', () {
    test('starts with empty countries and cities', () {
      expect(cubit.state.countries, isEmpty);
      expect(cubit.state.cities, isEmpty);
      expect(cubit.state.selectedCountry, isNull);
      expect(cubit.state.isLoadingCountries, false);
      expect(cubit.state.isLoadingCities, false);
    });
  });

  group('loadCountries', () {
    test('emits loading then countries on success', () async {
      when(() => repository.getAllCountries()).thenAnswer((_) async => testCountries);

      final expected = [
        const LocationState(isLoadingCountries: true),
        LocationState(isLoadingCountries: false, countries: testCountries),
      ];

      expectLater(cubit.stream, emitsInOrder(expected));
      cubit.loadCountries();
    });

    test('emits loading then error on failure', () async {
      when(() => repository.getAllCountries()).thenThrow(Exception('Network error'));

      final expected = [
        const LocationState(isLoadingCountries: true),
        const LocationState(isLoadingCountries: false, error: 'Exception: Network error'),
      ];

      expectLater(cubit.stream, emitsInOrder(expected));
      cubit.loadCountries();
    });
  });

  group('selectCountry', () {
    test('loads cities for selected country and stores it', () async {
      when(() => repository.getCitiesByCountry('sy')).thenAnswer((_) async => testCities);

      final country = testCountries[0];
      final expected = [
        LocationState(
          selectedCountry: country,
          cities: [],
          isLoadingCities: true,
        ),
        LocationState(
          selectedCountry: country,
          cities: testCities,
          isLoadingCities: false,
        ),
      ];

      expectLater(cubit.stream, emitsInOrder(expected));
      cubit.selectCountry(country);
      await Future(() {});
      expect(cubit.state.selectedCountry, equals(country));
    });

    test('emits error when getCitiesByCountry fails', () async {
      when(() => repository.getCitiesByCountry('sy')).thenThrow(Exception('Server error'));

      final country = testCountries[0];
      final expected = [
        LocationState(
          selectedCountry: country,
          cities: [],
          isLoadingCities: true,
        ),
        LocationState(
          selectedCountry: country,
          isLoadingCities: false,
          error: 'Exception: Server error',
        ),
      ];

      expectLater(cubit.stream, emitsInOrder(expected));
      cubit.selectCountry(country);
    });
  });

  group('searchCities', () {
    test('returns filtered cities on success', () async {
      when(() => repository.searchCities(any(), countryId: any(named: 'countryId')))
          .thenAnswer((_) async => [testCities[0]]);

      final expected = [
        LocationState(isLoadingCities: true),
        LocationState(isLoadingCities: false, cities: [testCities[0]]),
      ];

      expectLater(cubit.stream, emitsInOrder(expected));
      cubit.searchCities('دمشق', countryId: 'sy');
    });

    test('returns filtered cities without countryId', () async {
      when(() => repository.searchCities(any(), countryId: any(named: 'countryId')))
          .thenAnswer((_) async => []);

      final expected = [
        LocationState(isLoadingCities: true),
        LocationState(isLoadingCities: false, cities: []),
      ];

      expectLater(cubit.stream, emitsInOrder(expected));
      cubit.searchCities('xx');
    });
  });

  group('clearError', () {
    test('clears error from state', () {
      cubit.emit(const LocationState(error: 'Some error'));
      cubit.clearError();
      expect(cubit.state.error, isNull);
    });
  });
}
