import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import '../models/daily_note.dart';
import '../models/expense_entry.dart';
import '../models/habit.dart';
import '../models/habit_check_in.dart';
import '../models/mood_entry.dart';
import '../models/todo_item.dart';

class FirestorePlannerApi {
  bool get isConfigured => Firebase.apps.isNotEmpty;

  Future<void> upsertExpense(ExpenseEntry expense) {
    return _set(
      userId: expense.userId,
      collection: 'expenses',
      id: expense.id,
      data: expense.toJson(),
    );
  }

  Future<void> upsertTodo(TodoItem todo) {
    return _set(
      userId: todo.userId,
      collection: 'todos',
      id: todo.id,
      data: todo.toJson(),
    );
  }

  Future<void> upsertNote(DailyNote note) {
    return _set(
      userId: note.userId,
      collection: 'notes',
      id: note.id,
      data: note.toJson(),
    );
  }

  Future<void> upsertMood(MoodEntry mood) {
    return _set(
      userId: mood.userId,
      collection: 'moods',
      id: mood.id,
      data: mood.toJson(),
    );
  }

  Future<void> upsertHabit(Habit habit) {
    return _set(
      userId: habit.userId,
      collection: 'habits',
      id: habit.id,
      data: habit.toJson(),
    );
  }

  Future<void> upsertHabitCheckIn(HabitCheckIn checkIn) {
    return _set(
      userId: checkIn.userId,
      collection: 'habitCheckIns',
      id: checkIn.id,
      data: checkIn.toJson(),
    );
  }

  Future<void> _set({
    required String userId,
    required String collection,
    required String id,
    required Map<String, dynamic> data,
  }) async {
    if (!isConfigured) {
      throw StateError('Firebase config is missing');
    }

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection(collection)
        .doc(id)
        .set(data, SetOptions(merge: true));
  }
}
