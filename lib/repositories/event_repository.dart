import '../local/local_event_dao.dart';
import '../local/local_event_store.dart';
import '../models/calendar_event.dart';
import '../models/sync_metadata.dart';

class EventRepository {
  EventRepository(this._localEventDao);

  final LocalEventDao _localEventDao;

  Future<List<CalendarEvent>> getEvents() {
    return _localEventDao.getEvents();
  }

  Future<void> saveEvent(CalendarEvent event) {
    return _localEventDao.saveEvent(event);
  }

  Future<List<CalendarEvent>> getPendingSyncEvents() {
    return _localEventDao.getPendingSyncEvents();
  }

  Future<void> updateSyncStatus(String eventId, SyncStatus syncStatus) {
    return _localEventDao.updateSyncStatus(eventId, syncStatus);
  }
}

EventRepository createEventRepository() {
  return EventRepository(LocalEventDao(LocalEventStore()));
}
