class ApiConfig {
  static const String baseUrl = 'http://10.164.20.236:8000';
  static const String apiPrefix = '/api/v1';
  static String get apiUrl => '$baseUrl$apiPrefix';
}
