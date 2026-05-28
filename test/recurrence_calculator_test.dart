import 'package:cute_calendar/models/calendar_event.dart';
import 'package:cute_calendar/models/recurrence_rule.dart';
import 'package:cute_calendar/models/sync_metadata.dart';
import 'package:cute_calendar/recurrence/recurrence_calculator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const calculator = RecurrenceCalculator();

  test('matches weekly recurring events', () {
    final event = _event(
      startAt: DateTime(2026, 5, 18, 9),
      recurrenceRule: const RecurrenceRule(
        frequency: RecurrenceFrequency.weekly,
      ),
    );

    expect(calculator.occursOn(event, DateTime(2026, 5, 25)), isTrue);
    expect(calculator.occursOn(event, DateTime(2026, 5, 26)), isFalse);
  });

  test('creates an occurrence on the requested day', () {
    final event = _event(
      startAt: DateTime(2026, 5, 18, 9, 30),
      recurrenceRule: const RecurrenceRule(
        frequency: RecurrenceFrequency.daily,
      ),
    );

    final occurrence = calculator.occurrenceFor(event, DateTime(2026, 5, 20));

    expect(occurrence.startAt, DateTime(2026, 5, 20, 9, 30));
    expect(occurrence.endAt, DateTime(2026, 5, 20, 10, 30));
  });
}

CalendarEvent _event({
  required DateTime startAt,
  required RecurrenceRule recurrenceRule,
}) {
  return CalendarEvent(
    id: 'event-1',
    userId: 'local-user',
    title: 'Plan',
    description: '',
    location: '',
    startAt: startAt,
    endAt: startAt.add(const Duration(hours: 1)),
    isAllDay: false,
    color: 0xFF7CC8FF,
    reminders: const [],
    recurrenceRule: recurrenceRule,
    createdAt: startAt,
    updatedAt: startAt,
    syncStatus: SyncStatus.localOnly,
    version: 1,
  );
}
