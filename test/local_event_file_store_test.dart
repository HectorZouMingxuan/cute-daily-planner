import 'dart:convert';
import 'dart:io';

import 'package:cute_calendar/local/local_event_store_io.dart';
import 'package:cute_calendar/models/calendar_event.dart';
import 'package:cute_calendar/models/recurrence_rule.dart';
import 'package:cute_calendar/models/sync_metadata.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('saves events to a JSON file', () async {
    final directory = Directory.systemTemp.createTempSync(
      'calendar_file_store_',
    );
    final file = File('${directory.path}/calendar_events.json');
    final store = LocalEventStore(filePath: file.path);
    final now = DateTime(2026, 5, 16, 10);

    final event = CalendarEvent(
      id: 'file-event',
      userId: 'local-user',
      title: 'Saved in file',
      description: '',
      location: '',
      startAt: now,
      endAt: now.add(const Duration(hours: 1)),
      isAllDay: false,
      color: 0xFF7CC8FF,
      reminders: const [],
      recurrenceRule: const RecurrenceRule(),
      createdAt: now,
      updatedAt: now,
      syncStatus: SyncStatus.localOnly,
      version: 1,
    );

    await store.put(event.id, event.toJson());

    final json = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
    expect(json['events']['file-event']['title'], 'Saved in file');

    directory.deleteSync(recursive: true);
  });
}
