import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../firebase/firestore_event_dao.dart';
import '../local/local_event_dao.dart';
import '../local/local_event_store.dart';
import '../models/calendar_event.dart';
import '../repositories/event_repository.dart';
import '../repositories/notification_repository.dart';
import 'user_provider.dart';

final eventRepositoryProvider = Provider<EventRepository>((ref) {
  final firestore = ref.read(firestoreProvider);
  final dao = FirestoreEventDao(firestore);
  return EventRepository(LocalEventDao(LocalEventStore()), firestoreDao: dao);
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
    final userId = ref.read(currentUserIdProvider);
    return _repository.getEvents(userId: userId);
  }

  Future<void> refreshEvents() async {
    final userId = ref.read(currentUserIdProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _repository.getEvents(userId: userId),
    );
  }

  Future<void> saveEvent(CalendarEvent event) async {
    final userId = ref.read(currentUserIdProvider);
    await _repository.saveEvent(event, userId: userId);
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
    final userId = ref.read(currentUserIdProvider);
    await _repository.saveEvent(deletedEvent, userId: userId);
    await refreshEvents();
  }
}
