import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

class CacheService {
  static const _boxName = 'api_cache';
  static const _maxEntries = 50;
  static const _expiryHours = 1;
  static CacheService? _instance;

  late Box<String> _box;

  CacheService._();

  static Future<CacheService> init() async {
    _instance ??= CacheService._();
    _instance!._box = await Hive.openBox<String>(_boxName);
    await _instance!._removeExpired();
    return _instance!;
  }

  static CacheService get instance => _instance!;

  void put(String key, Map<String, dynamic> data) {
    final entry = {
      'data': data,
      't': DateTime.now().millisecondsSinceEpoch,
    };
    _box.put(key, jsonEncode(entry));
    _enforceMaxEntries();
  }

  Map<String, dynamic>? get(String key) {
    final raw = _box.get(key);
    if (raw == null) return null;
    try {
      final entry = jsonDecode(raw) as Map;
      final timestamp = entry['t'] as int?;
      if (timestamp != null) {
        final age = DateTime.now().millisecondsSinceEpoch - timestamp;
        if (age > _expiryHours * 3600000) {
          _box.delete(key);
          return null;
        }
      }
      return entry['data'] as Map<String, dynamic>?;
    } catch (_) {
      _box.delete(key);
      return null;
    }
  }

  Future<void> clear() async {
    await _box.clear();
  }

  void _enforceMaxEntries() {
    if (_box.length <= _maxEntries) return;
    final sorted = _box.toMap().entries
      .map((e) => (key: e.key, raw: e.value))
      .map((e) {
        final ts = _parseTimestamp(e.raw);
        return (key: e.key, timestamp: ts);
      })
      .toList()
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
    final toRemove = sorted.take(sorted.length - _maxEntries);
    for (final item in toRemove) {
      _box.delete(item.key);
    }
  }

  Future<void> _removeExpired() async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final keys = _box.keys.toList();
    for (final key in keys) {
      final raw = _box.get(key);
      if (raw == null) continue;
      final ts = _parseTimestamp(raw);
      if (ts > 0 && now - ts > _expiryHours * 3600000) {
        await _box.delete(key);
      }
    }
  }

  int _parseTimestamp(String raw) {
    try {
      final entry = jsonDecode(raw) as Map;
      return entry['t'] as int? ?? 0;
    } catch (_) {
      return 0;
    }
  }
}
