import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/habit.dart';
import '../models/habit_check_in.dart';
import '../repositories/habit_repository.dart';

class HabitState {
  const HabitState({required this.habits, required this.checkIns});

  final List<Habit> habits;
  final List<HabitCheckIn> checkIns;
}

final habitRepositoryProvider = Provider<HabitRepository>((ref) {
  return createHabitRepository();
});

final habitProvider = AsyncNotifierProvider<HabitController, HabitState>(
  HabitController.new,
);

class HabitController extends AsyncNotifier<HabitState> {
  HabitRepository get _repository => ref.read(habitRepositoryProvider);

  @override
  Future<HabitState> build() async {
    return HabitState(
      habits: await _repository.getHabits(),
      checkIns: await _repository.getCheckIns(),
    );
  }

  Future<void> saveHabit(Habit habit) async {
    await _repository.saveHabit(habit);
    state = await AsyncValue.guard(build);
  }

  Future<void> saveCheckIn(HabitCheckIn checkIn) async {
    await _repository.saveCheckIn(checkIn);
    state = await AsyncValue.guard(build);
  }

  Future<void> deleteHabit(String habitId) async {
    final currentState = state.value;
    if (currentState == null) return;
    final habit = currentState.habits.firstWhere((h) => h.id == habitId);
    final deleted = Habit(
      id: habit.id,
      userId: habit.userId,
      title: habit.title,
      icon: habit.icon,
      color: habit.color,
      createdAt: habit.createdAt,
      updatedAt: DateTime.now(),
      deletedAt: DateTime.now(),
      syncStatus: habit.syncStatus,
      version: habit.version + 1,
    );
    await _repository.saveHabit(deleted);
    state = await AsyncValue.guard(build);
  }
}
