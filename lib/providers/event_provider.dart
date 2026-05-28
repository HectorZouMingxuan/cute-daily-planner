import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/calendar_event.dart';
import '../repositories/event_repository.dart';
import '../repositories/notification_repository.dart';

final eventRepositoryProvider = Provider<EventRepository>((ref) {
  return createEventRepository();
});

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return createNotificationRepository();
});

final eventListProvider =
    AsyncNotifierProvider<EventListController, List<CalendarEvent>>(
      EventListController.new,
    );

class EventListController extends AsyncNotifier<List<CalendarEvent>> {
  EventRepository get _repository => ref.read(eventRepositoryProvider);
  NotificationRepository get _notificationRepository =>
      ref.read(notificationRepositoryProvider);

  @override
  Future<List<CalendarEvent>> build() {
    return _repository.getEvents();
  }

  Future<void> refreshEvents() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_repository.getEvents);
  }

  Future<void> saveEvent(CalendarEvent event) async {
    await _repository.saveEvent(event);
    await _notificationRepository.rescheduleEvent(event);
    await refreshEvents();
  }

  Future<void> deleteEvent(CalendarEvent event) async {
    await _notificationRepository.cancelEvent(event);
    final deletedEvent = event.copyWith(
      deletedAt: DateTime.now(),
      updatedAt: DateTime.now(),
      version: event.version + 1,
    );
    await _repository.saveEvent(deletedEvent);
    await refreshEvents();
  }
}
