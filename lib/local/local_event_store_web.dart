import 'package:hive_flutter/hive_flutter.dart';

class LocalEventStore {
  static const _boxName = 'calendar_events';

  Future<List<Map<String, dynamic>>> getAll() async {
    final box = await Hive.openBox<Map>(_boxName);
    return box.values.map((event) => Map<String, dynamic>.from(event)).toList();
  }

  Future<Map<String, dynamic>?> getById(String id) async {
    final box = await Hive.openBox<Map>(_boxName);
    final event = box.get(id);
    if (event == null) {
      return null;
    }
    return Map<String, dynamic>.from(event);
  }

  Future<void> put(String id, Map<String, dynamic> event) async {
    final box = await Hive.openBox<Map>(_boxName);
    await box.put(id, event);
  }
}
