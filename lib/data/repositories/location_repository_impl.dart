import 'package:clinic_management_app/data/datasources/location_data_source.dart';
import 'package:clinic_management_app/data/datasources/remote/location_remote_datasource.dart';
import 'package:clinic_management_app/domain/entities/country_entity.dart';
import 'package:clinic_management_app/domain/entities/city_entity.dart';
import 'package:clinic_management_app/domain/repositories/location_repository.dart';

class LocationRepositoryImpl implements LocationRepository {
  final LocationDataSource dataSource;
  final LocationRemoteDataSource? remoteDataSource;

  LocationRepositoryImpl(this.dataSource, {this.remoteDataSource});

  @override
  Future<List<CountryEntity>> getAllCountries() async {
    if (remoteDataSource != null) {
      try {
        return await remoteDataSource!.getCountries();
      } catch (_) {}
    }
    return dataSource.allCountries;
  }

  @override
  Future<List<CityEntity>> getCitiesByCountry(String countryId) async {
    if (remoteDataSource != null) {
      try {
        return await remoteDataSource!.getCities(countryId: countryId);
      } catch (_) {}
    }
    return dataSource.citiesByCountry(countryId);
  }

  @override
  Future<List<CityEntity>> searchCities(String query, {String? countryId}) async {
    if (remoteDataSource != null) {
      try {
        return await remoteDataSource!.getCities(search: query, countryId: countryId);
      } catch (_) {}
    }
    return dataSource.searchCities(query, countryId: countryId);
  }
}
