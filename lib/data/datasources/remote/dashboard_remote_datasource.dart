import 'package:clinic_management_app/core/services/api_service.dart';

class DashboardRemoteDataSource {
  final ApiService _api;

  DashboardRemoteDataSource(this._api);

  Future<Map<String, dynamic>> getDashboard() async {
    final response = await _api.get('/dashboard');
    return response.data as Map<String, dynamic>;
  }
}
