import '../local/local_collection_store.dart';
import '../local/local_habit_dao.dart';
import '../models/habit.dart';
import '../models/habit_check_in.dart';
import '../remote/firestore_planner_api.dart';

class HabitRepository {
  HabitRepository(this._dao, {FirestorePlannerApi? firestoreApi})
      : _firestoreApi = firestoreApi;

  final LocalHabitDao _dao;
  final FirestorePlannerApi? _firestoreApi;

  Future<List<Habit>> getHabits({String userId = 'local-user'}) async {
    final api = _firestoreApi;
    if (api != null) {
      try {
        final remote = await api.getHabits(userId);
        for (final habit in remote) {
          await _dao.saveHabit(habit);
        }
        return remote;
      } catch (_) {}
    }
    return _dao.getHabits();
  }

  Future<List<HabitCheckIn>> getCheckIns({String userId = 'local-user'}) async {
    final api = _firestoreApi;
    if (api != null) {
      try {
        final remote = await api.getHabitCheckIns(userId);
        for (final checkIn in remote) {
          await _dao.saveCheckIn(checkIn);
        }
        return remote;
      } catch (_) {}
    }
    return _dao.getCheckIns();
  }

  Future<void> saveHabit(Habit habit) async {
    await _dao.saveHabit(habit);

    final api = _firestoreApi;
    if (api != null) {
      try {
        await api.upsertHabit(habit);
      } catch (_) {}
    }
  }

  Future<void> saveCheckIn(HabitCheckIn checkIn) async {
    await _dao.saveCheckIn(checkIn);

    final api = _firestoreApi;
    if (api != null) {
      try {
        await api.upsertHabitCheckIn(checkIn);
      } catch (_) {}
    }
  }
}

HabitRepository createHabitRepository({FirestorePlannerApi? firestoreApi}) {
  return HabitRepository(
    LocalHabitDao(
      LocalCollectionStore('habits'),
      LocalCollectionStore('habit_check_ins'),
    ),
    firestoreApi: firestoreApi,
  );
}
