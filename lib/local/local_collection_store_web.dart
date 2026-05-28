import 'package:hive_flutter/hive_flutter.dart';

class LocalCollectionStore {
  LocalCollectionStore(this.name);

  final String name;

  Future<List<Map<String, dynamic>>> getAll() async {
    final box = await Hive.openBox<Map>(name);
    return box.values.map((item) => Map<String, dynamic>.from(item)).toList();
  }

  Future<void> put(String id, Map<String, dynamic> item) async {
    final box = await Hive.openBox<Map>(name);
    await box.put(id, item);
  }
}
