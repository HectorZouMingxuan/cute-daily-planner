import 'package:cute_calendar/app.dart';
import 'package:cute_calendar/models/calendar_event.dart';
import 'package:cute_calendar/models/sync_metadata.dart';
import 'package:cute_calendar/providers/event_provider.dart';
import 'package:cute_calendar/repositories/event_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows the calendar home screen', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          eventRepositoryProvider.overrideWithValue(_FakeEventRepository()),
        ],
        child: const CuteCalendarApp(),
      ),
    );
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Cute Daily Planner'), findsOneWidget);
    expect(find.text('Today'), findsOneWidget);
    expect(find.text('No events today', skipOffstage: false), findsOneWidget);
    expect(find.text('Add a little plan', skipOffstage: false), findsOneWidget);
  });
}

class _FakeEventRepository implements EventRepository {
  @override
  Future<List<CalendarEvent>> getEvents() async => [];

  @override
  Future<List<CalendarEvent>> getPendingSyncEvents() async => [];

  @override
  Future<void> saveEvent(CalendarEvent event) async {}

  @override
  Future<void> updateSyncStatus(String eventId, SyncStatus syncStatus) async {}
}
