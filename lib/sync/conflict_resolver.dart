import '../models/calendar_event.dart';

class ConflictResolver {
  const ConflictResolver();

  CalendarEvent chooseLatest(CalendarEvent local, CalendarEvent remote) {
    return local.updatedAt.isAfter(remote.updatedAt) ? local : remote;
  }
}
