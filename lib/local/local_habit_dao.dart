import '../models/habit.dart';
import '../models/habit_check_in.dart';
import 'local_collection_store.dart';

class LocalHabitDao {
  LocalHabitDao(this._habitStore, this._checkInStore);

  final LocalCollectionStore _habitStore;
  final LocalCollectionStore _checkInStore;

  Future<List<Habit>> getHabits() async {
    final items = await _habitStore.getAll();
    return items.map(Habit.fromJson).where((habit) => !habit.isDeleted).toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
  }

  Future<List<HabitCheckIn>> getCheckIns() async {
    final items = await _checkInStore.getAll();
    return items.map(HabitCheckIn.fromJson).toList();
  }

  Future<void> saveHabit(Habit habit) {
    return _habitStore.put(habit.id, habit.toJson());
  }

  Future<void> saveCheckIn(HabitCheckIn checkIn) {
    return _checkInStore.put(checkIn.id, checkIn.toJson());
  }
}
