import '../firebase/firestore_event_dao.dart';
import '../local/local_event_dao.dart';
import '../local/local_event_store.dart';
import '../models/calendar_event.dart';
import '../models/sync_metadata.dart';

class EventRepository {
  EventRepository(this._localEventDao, {FirestoreEventDao? firestoreDao})
      : _firestoreDao = firestoreDao;

  final LocalEventDao _localEventDao;
  final FirestoreEventDao? _firestoreDao;

  Future<List<CalendarEvent>> getEvents({String userId = 'local-user'}) async {
    final localEvents = await _localEventDao.getEvents();

    // Try Firestore in background, merge on success
    final dao = _firestoreDao;
    if (dao != null) {
      try {
        final remoteEvents = await dao.getEvents(userId);
        _syncRemoteToLocal(remoteEvents);
        return remoteEvents;
      } catch (_) {
        // Firestore unavailable, fall back to local
      }
    }

    return localEvents;
  }

  Future<void> saveEvent(CalendarEvent event,
      {String userId = 'local-user'}) async {
    await _localEventDao.saveEvent(event);

    final dao = _firestoreDao;
    if (dao != null) {
      try {
        await dao.saveEvent(userId, event);
      } catch (_) {
        // Firestore write failed silently — local write succeeded
      }
    }
  }

  Future<List<CalendarEvent>> getPendingSyncEvents() {
    return _localEventDao.getPendingSyncEvents();
  }

  Future<void> updateSyncStatus(String eventId, SyncStatus syncStatus) {
    return _localEventDao.updateSyncStatus(eventId, syncStatus);
  }

  Future<void> _syncRemoteToLocal(List<CalendarEvent> remoteEvents) async {
    for (final event in remoteEvents) {
      await _localEventDao.saveEvent(event);
    }
  }
}

EventRepository createEventRepository() {
  return EventRepository(LocalEventDao(LocalEventStore()));
}
