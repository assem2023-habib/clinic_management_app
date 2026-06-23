import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

class CacheService {
  static const _boxName = 'api_cache';
  static CacheService? _instance;

  late Box<String> _box;

  CacheService._();

  static Future<CacheService> init() async {
    _instance ??= CacheService._();
    _instance!._box = await Hive.openBox<String>(_boxName);
    return _instance!;
  }

  static CacheService get instance => _instance!;

  void put(String key, Map<String, dynamic> data) {
    _box.put(key, jsonEncode(data));
  }

  Map<String, dynamic>? get(String key) {
    final raw = _box.get(key);
    if (raw == null) return null;
    return jsonDecode(raw) as Map<String, dynamic>?;
  }

  Future<void> clear() async {
    await _box.clear();
  }
}
