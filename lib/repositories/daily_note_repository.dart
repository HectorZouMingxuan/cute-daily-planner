import '../local/local_collection_store.dart';
import '../local/local_daily_note_dao.dart';
import '../models/daily_note.dart';
import '../remote/firestore_planner_api.dart';

class DailyNoteRepository {
  DailyNoteRepository(this._dao, {FirestorePlannerApi? firestoreApi})
      : _firestoreApi = firestoreApi;

  final LocalDailyNoteDao _dao;
  final FirestorePlannerApi? _firestoreApi;

  Future<List<DailyNote>> getNotes({String userId = 'local-user'}) async {
    final api = _firestoreApi;
    if (api != null) {
      try {
        final remote = await api.getNotes(userId);
        for (final note in remote) {
          await _dao.saveNote(note);
        }
        return remote;
      } catch (_) {}
    }
    return _dao.getNotes();
  }

  Future<void> saveNote(DailyNote note) async {
    await _dao.saveNote(note);

    final api = _firestoreApi;
    if (api != null) {
      try {
        await api.upsertNote(note);
      } catch (_) {}
    }
  }
}

DailyNoteRepository createDailyNoteRepository({
  FirestorePlannerApi? firestoreApi,
}) {
  return DailyNoteRepository(
    LocalDailyNoteDao(LocalCollectionStore('daily_notes')),
    firestoreApi: firestoreApi,
  );
}
