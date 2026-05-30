import 'package:clinic_management_app/core/services/api_service.dart';
import 'package:clinic_management_app/data/models/country_model.dart';
import 'package:clinic_management_app/data/models/city_model.dart';

class LocationRemoteDataSource {
  final ApiService _api;

  LocationRemoteDataSource(this._api);

  Future<List<CountryModel>> getCountries({int limit = 20, String? search}) async {
    final params = <String, dynamic>{'limit': limit};
    if (search != null) params['search'] = search;
    final response = await _api.get('/countries', queryParameters: params);
    final data = response.data['data'] as List<dynamic>? ?? [];
    return data.map((e) => CountryModel.fromMap(e as Map<String, dynamic>)).toList();
  }

  Future<CountryModel> getCountryById(String id) async {
    final response = await _api.get('/countries/$id');
    final data = response.data['data'] as Map<String, dynamic>;
    return CountryModel.fromMap(data);
  }

  Future<List<CityModel>> getCities({int limit = 20, String? countryId, String? search}) async {
    final params = <String, dynamic>{'limit': limit};
    if (countryId != null) params['country_id'] = countryId;
    if (search != null) params['search'] = search;
    final response = await _api.get('/cities', queryParameters: params);
    final data = response.data['data'] as List<dynamic>? ?? [];
    return data.map((e) => CityModel.fromMap(e as Map<String, dynamic>)).toList();
  }

  Future<CityModel> getCityById(String id) async {
    final response = await _api.get('/cities/$id');
    final data = response.data['data'] as Map<String, dynamic>;
    return CityModel.fromMap(data);
  }

  Future<CountryModel> createCountry(Map<String, dynamic> body) async {
    final response = await _api.post('/countries', data: body);
    return CountryModel.fromMap(response.data['data'] as Map<String, dynamic>);
  }

  Future<CountryModel> updateCountry(String id, Map<String, dynamic> body) async {
    final response = await _api.put('/countries/$id', data: body);
    return CountryModel.fromMap(response.data['data'] as Map<String, dynamic>);
  }

  Future<void> deleteCountry(String id) async {
    await _api.delete('/countries/$id');
  }

  Future<CityModel> createCity(Map<String, dynamic> body) async {
    final response = await _api.post('/cities', data: body);
    return CityModel.fromMap(response.data['data'] as Map<String, dynamic>);
  }

  Future<CityModel> updateCity(String id, Map<String, dynamic> body) async {
    final response = await _api.put('/cities/$id', data: body);
    return CityModel.fromMap(response.data['data'] as Map<String, dynamic>);
  }

  Future<void> deleteCity(String id) async {
    await _api.delete('/cities/$id');
  }
}
