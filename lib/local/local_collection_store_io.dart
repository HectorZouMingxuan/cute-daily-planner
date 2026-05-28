import 'dart:convert';
import 'dart:io';

class LocalCollectionStore {
  LocalCollectionStore(this.name);

  final String name;

  String get _filePath => 'data/$name.json';

  Future<List<Map<String, dynamic>>> getAll() async {
    final data = await _readData();
    final items = data['items'] as Map<String, dynamic>? ?? {};
    return items.values
        .map((item) => Map<String, dynamic>.from(item as Map))
        .toList();
  }

  Future<void> put(String id, Map<String, dynamic> item) async {
    final data = await _readData();
    final items = Map<String, dynamic>.from(
      data['items'] as Map<String, dynamic>? ?? {},
    );
    items[id] = item;
    data['items'] = items;
    await _writeData(data);
  }

  Future<Map<String, dynamic>> _readData() async {
    final file = File(_filePath);
    if (!file.existsSync()) {
      await file.parent.create(recursive: true);
      await file.writeAsString(
        const JsonEncoder.withIndent(
          '  ',
        ).convert({'items': <String, dynamic>{}}),
      );
    }
    final content = await file.readAsString();
    if (content.trim().isEmpty) {
      return {'items': <String, dynamic>{}};
    }
    return Map<String, dynamic>.from(jsonDecode(content) as Map);
  }

  Future<void> _writeData(Map<String, dynamic> data) async {
    final file = File(_filePath);
    await file.parent.create(recursive: true);
    await file.writeAsString(const JsonEncoder.withIndent('  ').convert(data));
  }
}
