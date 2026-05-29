import 'package:cute_calendar/app.dart';
import 'package:cute_calendar/models/calendar_event.dart';
import 'package:cute_calendar/models/sync_metadata.dart';
import 'package:cute_calendar/providers/event_provider.dart';
import 'package:cute_calendar/repositories/event_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows the login screen and navigates to calendar', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          eventRepositoryProvider.overrideWithValue(_FakeEventRepository()),
        ],
        child: const CuteCalendarApp(),
      ),
    );
    await tester.pumpAndSettle();

    // Should see login screen
    expect(find.text('Cute Daily Planner'), findsOneWidget);
    expect(find.text('Enter your name to get started'), findsOneWidget);

    // Log in
    await tester.enterText(find.byType(TextField), 'TestUser');
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    // Should see calendar screen
    expect(find.text('Hi, TestUser'), findsOneWidget);
    expect(find.text('Today'), findsOneWidget);
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
