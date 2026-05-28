import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/daily_note.dart';
import '../repositories/daily_note_repository.dart';

final dailyNoteRepositoryProvider = Provider<DailyNoteRepository>((ref) {
  return createDailyNoteRepository();
});

final dailyNoteListProvider =
    AsyncNotifierProvider<DailyNoteListController, List<DailyNote>>(
      DailyNoteListController.new,
    );

class DailyNoteListController extends AsyncNotifier<List<DailyNote>> {
  DailyNoteRepository get _repository => ref.read(dailyNoteRepositoryProvider);

  @override
  Future<List<DailyNote>> build() => _repository.getNotes();

  Future<void> saveNote(DailyNote note) async {
    await _repository.saveNote(note);
    state = await AsyncValue.guard(_repository.getNotes);
  }
}
