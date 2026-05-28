import '../local/local_collection_store.dart';
import '../local/local_mood_dao.dart';
import '../models/mood_entry.dart';

class MoodRepository {
  MoodRepository(this._dao);

  final LocalMoodDao _dao;

  Future<List<MoodEntry>> getMoods() => _dao.getMoods();

  Future<void> saveMood(MoodEntry mood) => _dao.saveMood(mood);
}

MoodRepository createMoodRepository() {
  return MoodRepository(LocalMoodDao(LocalCollectionStore('moods')));
}
