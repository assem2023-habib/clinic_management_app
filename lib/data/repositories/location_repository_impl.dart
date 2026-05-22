import 'package:clinic_management_app/data/datasources/data_source.dart';
import 'package:clinic_management_app/domain/entities/country_entity.dart';
import 'package:clinic_management_app/domain/entities/city_entity.dart';
import 'package:clinic_management_app/domain/repositories/location_repository.dart';

class LocationRepositoryImpl implements LocationRepository {
  final DataSource dataSource;

  LocationRepositoryImpl(this.dataSource);

  @override
  Future<List<CountryEntity>> getAllCountries() async => dataSource.allCountries;

  @override
  Future<List<CityEntity>> getCitiesByCountry(String countryId) async =>
      dataSource.citiesByCountry(countryId);

  @override
  Future<List<CityEntity>> searchCities(String query, {String? countryId}) async =>
      dataSource.searchCities(query, countryId: countryId);
}
