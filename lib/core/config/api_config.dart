class ApiConfig {
  static const String baseUrl = 'http://localhost:8000';
  static const String apiPrefix = '/api/v1';
  static String get apiUrl => '$baseUrl$apiPrefix';
}
