import '../local/local_collection_store.dart';
import '../local/local_mood_dao.dart';
import '../models/mood_entry.dart';
import '../remote/firestore_planner_api.dart';

class MoodRepository {
  MoodRepository(this._dao, {FirestorePlannerApi? firestoreApi})
      : _firestoreApi = firestoreApi;

  final LocalMoodDao _dao;
  final FirestorePlannerApi? _firestoreApi;

  Future<List<MoodEntry>> getMoods({String userId = 'local-user'}) async {
    final api = _firestoreApi;
    if (api != null) {
      try {
        final remote = await api.getMoods(userId);
        for (final mood in remote) {
          await _dao.saveMood(mood);
        }
        return remote;
      } catch (_) {}
    }
    return _dao.getMoods();
  }

  Future<void> saveMood(MoodEntry mood) async {
    await _dao.saveMood(mood);

    final api = _firestoreApi;
    if (api != null) {
      try {
        await api.upsertMood(mood);
      } catch (_) {}
    }
  }
}

MoodRepository createMoodRepository({FirestorePlannerApi? firestoreApi}) {
  return MoodRepository(
    LocalMoodDao(LocalCollectionStore('moods')),
    firestoreApi: firestoreApi,
  );
}
