import '../models/mood_entry.dart';
import 'local_collection_store.dart';

class LocalMoodDao {
  LocalMoodDao(this._store);

  final LocalCollectionStore _store;

  Future<List<MoodEntry>> getMoods() async {
    final items = await _store.getAll();
    return items.map(MoodEntry.fromJson).toList();
  }

  Future<void> saveMood(MoodEntry mood) {
    return _store.put(mood.id, mood.toJson());
  }
}
