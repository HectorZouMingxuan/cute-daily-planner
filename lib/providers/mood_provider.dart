import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/mood_entry.dart';
import '../repositories/mood_repository.dart';

final moodRepositoryProvider = Provider<MoodRepository>((ref) {
  return createMoodRepository();
});

final moodListProvider =
    AsyncNotifierProvider<MoodListController, List<MoodEntry>>(
      MoodListController.new,
    );

class MoodListController extends AsyncNotifier<List<MoodEntry>> {
  MoodRepository get _repository => ref.read(moodRepositoryProvider);

  @override
  Future<List<MoodEntry>> build() => _repository.getMoods();

  Future<void> saveMood(MoodEntry mood) async {
    await _repository.saveMood(mood);
    state = await AsyncValue.guard(_repository.getMoods);
  }
}
