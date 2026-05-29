import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/daily_note.dart';
import '../repositories/daily_note_repository.dart';
import 'user_provider.dart';

final dailyNoteRepositoryProvider = Provider<DailyNoteRepository>((ref) {
  final api = ref.read(firestorePlannerApiProvider);
  return createDailyNoteRepository(firestoreApi: api);
});

final dailyNoteListProvider =
    AsyncNotifierProvider<DailyNoteListController, List<DailyNote>>(
      DailyNoteListController.new,
    );

class DailyNoteListController extends AsyncNotifier<List<DailyNote>> {
  DailyNoteRepository get _repository => ref.read(dailyNoteRepositoryProvider);

  @override
  Future<List<DailyNote>> build() {
    final userId = ref.read(currentUserIdProvider);
    return _repository.getNotes(userId: userId);
  }

  Future<void> refreshNotes() async {
    final userId = ref.read(currentUserIdProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repository.getNotes(userId: userId));
  }

  Future<void> saveNote(DailyNote note) async {
    await _repository.saveNote(note);
    await refreshNotes();
  }
}
