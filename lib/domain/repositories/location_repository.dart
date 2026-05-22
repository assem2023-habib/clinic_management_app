import 'package:clinic_management_app/domain/entities/country_entity.dart';
import 'package:clinic_management_app/domain/entities/city_entity.dart';

abstract class LocationRepository {
  Future<List<CountryEntity>> getAllCountries();
  Future<List<CityEntity>> getCitiesByCountry(String countryId);
  Future<List<CityEntity>> searchCities(String query, {String? countryId});
}
