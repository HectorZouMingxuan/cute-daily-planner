import 'dart:convert';
import 'dart:io';

class LocalEventStore {
  LocalEventStore({String? filePath})
    : _filePath = filePath ?? 'data/calendar_events.json';

  final String _filePath;

  Future<List<Map<String, dynamic>>> getAll() async {
    final data = await _readData();
    final events = data['events'] as Map<String, dynamic>? ?? {};
    return events.values
        .map((event) => Map<String, dynamic>.from(event as Map))
        .toList();
  }

  Future<Map<String, dynamic>?> getById(String id) async {
    final data = await _readData();
    final events = data['events'] as Map<String, dynamic>? ?? {};
    final event = events[id];
    if (event == null) {
      return null;
    }
    return Map<String, dynamic>.from(event as Map);
  }

  Future<void> put(String id, Map<String, dynamic> event) async {
    final data = await _readData();
    final events = Map<String, dynamic>.from(
      data['events'] as Map<String, dynamic>? ?? {},
    );
    events[id] = event;
    data['events'] = events;
    await _writeData(data);
  }

  Future<Map<String, dynamic>> _readData() async {
    final file = File(_filePath);
    if (!file.existsSync()) {
      await file.parent.create(recursive: true);
      await file.writeAsString(
        const JsonEncoder.withIndent(
          '  ',
        ).convert({'events': <String, dynamic>{}}),
      );
    }

    final content = await file.readAsString();
    if (content.trim().isEmpty) {
      return {'events': <String, dynamic>{}};
    }

    return Map<String, dynamic>.from(jsonDecode(content) as Map);
  }

  Future<void> _writeData(Map<String, dynamic> data) async {
    final file = File(_filePath);
    await file.parent.create(recursive: true);
    await file.writeAsString(const JsonEncoder.withIndent('  ').convert(data));
  }
}
