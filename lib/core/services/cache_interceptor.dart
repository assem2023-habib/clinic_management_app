import 'package:dio/dio.dart';
import 'package:clinic_management_app/core/services/cache_service.dart';

class CacheInterceptor extends Interceptor {
  static const _excludedPrefixes = [
    '/appointments',
    '/booked-slots',
    '/medical-records',
    '/prescriptions',
    '/medicines',
    '/files',
    '/supervision-requests',
    '/available-doctors',
  ];

  final _memoryCache = <String, Map<String, dynamic>>{};

  bool _shouldCache(RequestOptions options) {
    final path = Uri.parse(options.uri.toString()).path;
    return !_excludedPrefixes.any((p) => path.contains(p));
  }

  @override
  void onResponse(Response response, handler) {
    if (response.requestOptions.method == 'GET' && response.statusCode == 200 && response.data is Map) {
      if (_shouldCache(response.requestOptions)) {
        final key = _cacheKey(response.requestOptions);
        final data = response.data as Map<String, dynamic>;
        if (data.containsKey('data')) {
          _memoryCache[key] = data;
          try { CacheService.instance.put(key, data); } catch (_) {}
        }
      }
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, handler) {
    if (err.requestOptions.method == 'GET') {
      final key = _cacheKey(err.requestOptions);
      final cached = _memoryCache[key] ?? CacheService.instance.get(key);
      if (cached != null) {
        _memoryCache[key] = cached;
        handler.resolve(Response(
          requestOptions: err.requestOptions,
          data: cached,
          statusCode: 200,
        ));
        return;
      }
    }
    handler.next(err);
  }

  String _cacheKey(RequestOptions options) {
    final uri = Uri.parse(options.uri.toString());
    final params = Map<String, dynamic>.from(uri.queryParameters);
    params.remove('page');
    params.remove('limit');
    final cleaned = uri.replace(queryParameters: params.isNotEmpty ? params : null);
    return cleaned.toString();
  }

  void invalidateByPrefix(String prefix) {
    _memoryCache.removeWhere((k, _) => k.contains(prefix));
  }

  Future<void> clearAll() async {
    _memoryCache.clear();
    await CacheService.instance.clear();
  }

  Response? tryServeFromCache(RequestOptions options) {
    final key = _cacheKey(options);
    final cached = _memoryCache[key] ?? CacheService.instance.get(key);
    if (cached != null) {
      _memoryCache[key] = cached;
      return Response(requestOptions: options, data: cached, statusCode: 200);
    }
    return null;
  }
}
