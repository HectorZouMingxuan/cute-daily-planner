import '../local/local_collection_store.dart';
import '../local/local_daily_note_dao.dart';
import '../models/daily_note.dart';

class DailyNoteRepository {
  DailyNoteRepository(this._dao);

  final LocalDailyNoteDao _dao;

  Future<List<DailyNote>> getNotes() => _dao.getNotes();

  Future<void> saveNote(DailyNote note) => _dao.saveNote(note);
}

DailyNoteRepository createDailyNoteRepository() {
  return DailyNoteRepository(
    LocalDailyNoteDao(LocalCollectionStore('daily_notes')),
  );
}
