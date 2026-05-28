import '../local/local_collection_store.dart';
import '../local/local_habit_dao.dart';
import '../models/habit.dart';
import '../models/habit_check_in.dart';

class HabitRepository {
  HabitRepository(this._dao);

  final LocalHabitDao _dao;

  Future<List<Habit>> getHabits() => _dao.getHabits();

  Future<List<HabitCheckIn>> getCheckIns() => _dao.getCheckIns();

  Future<void> saveHabit(Habit habit) => _dao.saveHabit(habit);

  Future<void> saveCheckIn(HabitCheckIn checkIn) => _dao.saveCheckIn(checkIn);
}

HabitRepository createHabitRepository() {
  return HabitRepository(
    LocalHabitDao(
      LocalCollectionStore('habits'),
      LocalCollectionStore('habit_check_ins'),
    ),
  );
}
