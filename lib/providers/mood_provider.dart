import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/mood_entry.dart';
import '../repositories/mood_repository.dart';
import 'user_provider.dart';

final moodRepositoryProvider = Provider<MoodRepository>((ref) {
  final api = ref.read(firestorePlannerApiProvider);
  return createMoodRepository(firestoreApi: api);
});

final moodListProvider =
    AsyncNotifierProvider<MoodListController, List<MoodEntry>>(
      MoodListController.new,
    );

class MoodListController extends AsyncNotifier<List<MoodEntry>> {
  MoodRepository get _repository => ref.read(moodRepositoryProvider);

  @override
  Future<List<MoodEntry>> build() {
    final userId = ref.read(currentUserIdProvider);
    return _repository.getMoods(userId: userId);
  }

  Future<void> refreshMoods() async {
    final userId = ref.read(currentUserIdProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repository.getMoods(userId: userId));
  }

  Future<void> saveMood(MoodEntry mood) async {
    await _repository.saveMood(mood);
    await refreshMoods();
  }
}
