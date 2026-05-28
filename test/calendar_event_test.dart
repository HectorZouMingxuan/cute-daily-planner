import 'package:cute_calendar/models/calendar_event.dart';
import 'package:cute_calendar/models/event_reminder.dart';
import 'package:cute_calendar/models/recurrence_rule.dart';
import 'package:cute_calendar/models/sync_metadata.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('CalendarEvent serializes and deserializes', () {
    final now = DateTime(2026, 5, 16, 9);
    final event = CalendarEvent(
      id: 'event-1',
      userId: 'local-user',
      title: 'Morning plan',
      description: 'A gentle start',
      location: 'Home',
      startAt: now,
      endAt: now.add(const Duration(hours: 1)),
      isAllDay: false,
      color: 0xFF7CC8FF,
      reminders: const [EventReminder(minutesBefore: 10)],
      recurrenceRule: const RecurrenceRule(
        frequency: RecurrenceFrequency.weekly,
      ),
      createdAt: now,
      updatedAt: now,
      syncStatus: SyncStatus.localOnly,
      version: 1,
    );

    final restored = CalendarEvent.fromJson(event.toJson());

    expect(restored.id, event.id);
    expect(restored.title, event.title);
    expect(restored.reminders.single.label, '10 minutes before');
    expect(restored.recurrenceRule.label, 'Weekly');
    expect(restored.syncStatus.label, 'Local only');
  });
}
