import 'dart:developer' as dev;

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:clinic_management_app/core/services/cache_interceptor.dart';

class ApiService {
  late final Dio _dio;
  bool _isRefreshing = false;
  static const String _tokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';

  static void Function()? onRateLimit;
  static void Function()? onNetworkError;
  static void Function()? onServerError;
  static void Function()? onForbidden;
  static void Function()? onSuspended;
  static void Function()? onSessionExpired;
  static CacheInterceptor? cacheInterceptor;

  ApiService({String baseUrl = 'http://localhost:8000/api/v1'}) {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {'Accept': 'application/json'},
    ));

    final ci = CacheInterceptor();
    cacheInterceptor = ci;
    _dio.interceptors.addAll([
      ci,
      LogInterceptor(
        request: true,
        requestBody: true,
        responseBody: true,
        error: true,
        logPrint: (obj) => dev.log('[API] $obj'),
      ),
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) async {
        if (error.response?.statusCode == 429) {
          onRateLimit?.call();
          handler.resolve(Response(requestOptions: error.requestOptions, statusCode: 429, data: {}));
          return;
        }
        if (error.type == DioExceptionType.connectionError ||
            error.type == DioExceptionType.connectionTimeout ||
            error.type == DioExceptionType.receiveTimeout) {
          if (error.requestOptions.method == 'GET') {
            final cached = cacheInterceptor!.tryServeFromCache(error.requestOptions);
            if (cached != null) { handler.resolve(cached); return; }
          }
          onNetworkError?.call();
          handler.resolve(Response(requestOptions: error.requestOptions, statusCode: 0, data: {}));
          return;
        }
        if (error.response?.statusCode == 401) {
          if (_isRefreshing) {
            handler.next(error);
            return;
          }
          _isRefreshing = true;
          final refreshed = await _tryRefreshToken();
          _isRefreshing = false;
          if (refreshed) {
            final retryResponse = await _retry(error.requestOptions);
            handler.resolve(retryResponse);
            return;
          }
          await clearTokens();
          onSessionExpired?.call();
          handler.resolve(Response(requestOptions: error.requestOptions, statusCode: 401, data: {}));
          return;
        }
        if (error.response?.statusCode == 403) {
          onForbidden?.call();
          handler.resolve(Response(requestOptions: error.requestOptions, statusCode: 403, data: {}));
          return;
        }
        final statusCode = error.response?.statusCode;
        if (statusCode != null && statusCode >= 500 && statusCode < 600) {
          onServerError?.call();
          handler.resolve(Response(requestOptions: error.requestOptions, statusCode: statusCode, data: {}));
          return;
        }
        handler.next(error);
      },
      ),
    ]);
  }

  final _storage = const FlutterSecureStorage();

  Future<String?> getToken() => _storage.read(key: _tokenKey);

  Future<void> setToken(String token) => _storage.write(key: _tokenKey, value: token);

  Future<void> setRefreshToken(String token) => _storage.write(key: _refreshTokenKey, value: token);

  Future<String?> getRefreshToken() => _storage.read(key: _refreshTokenKey);

  static Future<void> clearCache() async {
    await cacheInterceptor?.clearAll();
  }

  Future<void> clearTokens() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _refreshTokenKey);
  }

  Future<bool> _tryRefreshToken() async {
    try {
      final refreshToken = await getRefreshToken();
      if (refreshToken == null) return false;

      final response = await Dio(BaseOptions(
        baseUrl: _dio.options.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      )).post(
        '/auth/refresh',
        data: {'refresh_token': refreshToken},
      );

      if (response.statusCode == 200) {
        final data = response.data['data'];
        await setToken(data['access_token'] as String);
        await setRefreshToken(data['refresh_token'] as String);
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  Future<Response> _retry(RequestOptions requestOptions) async {
    final token = await getToken();
    final options = Options(
      method: requestOptions.method,
      headers: {
        ...requestOptions.headers,
        'Authorization': 'Bearer $token',
      },
    );
    return _dio.request(requestOptions.path,
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters,
        options: options);
  }

  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) =>
      _dio.get(path, queryParameters: queryParameters);

  Future<Response> post(String path, {dynamic data}) =>
      _dio.post(path, data: data);

  Future<Response> put(String path, {dynamic data}) =>
      _dio.put(path, data: data);

  Future<Response> delete(String path, {dynamic data}) =>
      _dio.delete(path, data: data);

  Future<Response> upload(String path, FormData data) =>
      _dio.post(path, data: data);

  void updateBaseUrl(String url) {
    _dio.options.baseUrl = url;
  }
}
