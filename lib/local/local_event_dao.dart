import '../models/calendar_event.dart';
import '../models/sync_metadata.dart';
import 'local_event_store.dart';

class LocalEventDao {
  LocalEventDao(this._store);

  final LocalEventStore _store;

  Future<List<CalendarEvent>> getEvents() async {
    final events = await _store.getAll();
    return events
        .map(CalendarEvent.fromJson)
        .where((event) => !event.isDeleted)
        .toList()
      ..sort((a, b) => a.startAt.compareTo(b.startAt));
  }

  Future<void> saveEvent(CalendarEvent event) async {
    await _store.put(event.id, event.toJson());
  }

  Future<List<CalendarEvent>> getPendingSyncEvents() async {
    final events = await _store.getAll();
    return events
        .map(CalendarEvent.fromJson)
        .where((event) => event.syncStatus != SyncStatus.synced)
        .toList();
  }

  Future<void> updateSyncStatus(String eventId, SyncStatus syncStatus) async {
    final json = await _store.getById(eventId);
    if (json == null) {
      return;
    }

    final event = CalendarEvent.fromJson(json);
    await _store.put(eventId, event.copyWith(syncStatus: syncStatus).toJson());
  }
}
