import '../models/sync_metadata.dart';
import '../remote/firestore_event_api.dart';
import '../remote/firestore_planner_api.dart';
import '../repositories/event_repository.dart';

class SyncResult {
  const SyncResult({required this.status, required this.message});

  final SyncStatus status;
  final String message;
}

class SyncEngine {
  SyncEngine({
    required EventRepository eventRepository,
    required FirestoreEventApi firestoreEventApi,
    FirestorePlannerApi? firestorePlannerApi,
  }) : _eventRepository = eventRepository,
       _firestoreEventApi = firestoreEventApi,
       _firestorePlannerApi = firestorePlannerApi ?? FirestorePlannerApi();

  final EventRepository _eventRepository;
  final FirestoreEventApi _firestoreEventApi;
  final FirestorePlannerApi _firestorePlannerApi;

  Future<SyncResult> syncPendingEvents() async {
    if (!_firestoreEventApi.isConfigured ||
        !_firestorePlannerApi.isConfigured) {
      return const SyncResult(
        status: SyncStatus.syncFailed,
        message: 'Firebase config is missing',
      );
    }

    final pendingEvents = await _eventRepository.getPendingSyncEvents();
    for (final event in pendingEvents) {
      await _eventRepository.updateSyncStatus(event.id, SyncStatus.syncing);
      try {
        await _firestoreEventApi.upsertEvent(event);
        await _eventRepository.updateSyncStatus(event.id, SyncStatus.synced);
      } catch (_) {
        await _eventRepository.updateSyncStatus(
          event.id,
          SyncStatus.syncFailed,
        );
        return const SyncResult(
          status: SyncStatus.syncFailed,
          message: 'Sync failed',
        );
      }
    }

    return const SyncResult(status: SyncStatus.synced, message: 'Synced');
  }
}
