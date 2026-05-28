import '../models/daily_note.dart';
import 'local_collection_store.dart';

class LocalDailyNoteDao {
  LocalDailyNoteDao(this._store);

  final LocalCollectionStore _store;

  Future<List<DailyNote>> getNotes() async {
    final items = await _store.getAll();
    return items
        .map(DailyNote.fromJson)
        .where((note) => !note.isDeleted)
        .toList();
  }

  Future<void> saveNote(DailyNote note) {
    return _store.put(note.id, note.toJson());
  }
}
