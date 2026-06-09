import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

final class CacheService {
  static const _boxName = 'cache';
  static const _foodTtl = Duration(hours: 1);
  static const _exerciseTtl = Duration(days: 7);

  static late Box<String> _box;

  static Future<void> init() async {
    if (kIsWeb) {
      await Hive.init();
    } else {
      await Hive.initFlutter();
    }
    _box = await Hive.openBox<String>(_boxName);
  }

  static Future<void> cacheFoodSearch(String query, List<Map<String, dynamic>> results) async {
    await _box.put('food_$query', jsonEncode({
      'data': results,
      'ts': DateTime.now().millisecondsSinceEpoch,
    }));
  }

  static List<Map<String, dynamic>>? getCachedFoodSearch(String query) {
    final raw = _box.get('food_$query');
    if (raw == null) return null;
    final entry = jsonDecode(raw) as Map<String, dynamic>;
    final ts = DateTime.fromMillisecondsSinceEpoch(entry['ts'] as int);
    if (DateTime.now().difference(ts) > _foodTtl) {
      _box.delete('food_$query');
      return null;
    }
    return (entry['data'] as List).cast<Map<String, dynamic>>();
  }

  static Future<void> cacheExercises(String json) async {
    await _box.put('exercises', jsonEncode({
      'data': json,
      'ts': DateTime.now().millisecondsSinceEpoch,
    }));
  }

  static String? getCachedExercises() {
    final raw = _box.get('exercises');
    if (raw == null) return null;
    final entry = jsonDecode(raw) as Map<String, dynamic>;
    final ts = DateTime.fromMillisecondsSinceEpoch(entry['ts'] as int);
    if (DateTime.now().difference(ts) > _exerciseTtl) {
      _box.delete('exercises');
      return null;
    }
    return entry['data'] as String;
  }
}
