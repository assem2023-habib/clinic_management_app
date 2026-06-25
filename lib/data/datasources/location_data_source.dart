import 'package:clinic_management_app/data/models/country_model.dart';
import 'package:clinic_management_app/data/models/city_model.dart';

abstract class LocationDataSource {
  List<CountryModel> get allCountries;
  List<CityModel> get allCities;
  List<CityModel> citiesByCountry(String countryId);
  List<CityModel> searchCities(String query, {String? countryId});
}
