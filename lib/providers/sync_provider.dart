import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/sync_metadata.dart';
import '../remote/firestore_event_api.dart';
import '../sync/sync_engine.dart';
import 'event_provider.dart';

class SyncState {
  const SyncState({required this.status, required this.message});

  final SyncStatus status;
  final String message;
}

final syncProvider = NotifierProvider<SyncController, SyncState>(
  SyncController.new,
);

class SyncController extends Notifier<SyncState> {
  @override
  SyncState build() {
    return const SyncState(status: SyncStatus.localOnly, message: 'Local only');
  }

  Future<void> syncNow() async {
    state = const SyncState(status: SyncStatus.syncing, message: 'Syncing');
    final engine = SyncEngine(
      eventRepository: ref.read(eventRepositoryProvider),
      firestoreEventApi: FirestoreEventApi(),
    );
    final result = await engine.syncPendingEvents();
    state = SyncState(status: result.status, message: result.message);
    ref.invalidate(eventListProvider);
  }
}
