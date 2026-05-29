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

  // ── Read ──────────────────────────────────────────────────────

  Future<List<TodoItem>> getTodos(String userId) async {
    final snapshot = await _collection(userId, 'tasks').get();
    return snapshot.docs
        .map((doc) => TodoItem.fromJson(doc.data()))
        .where((t) => !t.isDeleted)
        .toList();
  }

  Future<List<ExpenseEntry>> getExpenses(String userId) async {
    final snapshot = await _collection(userId, 'expenses').get();
    return snapshot.docs
        .map((doc) => ExpenseEntry.fromJson(doc.data()))
        .where((e) => !e.isDeleted)
        .toList();
  }

  Future<List<MoodEntry>> getMoods(String userId) async {
    final snapshot = await _collection(userId, 'moods').get();
    return snapshot.docs
        .map((doc) => MoodEntry.fromJson(doc.data()))
        .toList();
  }

  Future<List<DailyNote>> getNotes(String userId) async {
    final snapshot = await _collection(userId, 'notes').get();
    return snapshot.docs
        .map((doc) => DailyNote.fromJson(doc.data()))
        .toList();
  }

  Future<List<Habit>> getHabits(String userId) async {
    final snapshot = await _collection(userId, 'habits').get();
    return snapshot.docs
        .map((doc) => Habit.fromJson(doc.data()))
        .where((h) => !h.isDeleted)
        .toList();
  }

  Future<List<HabitCheckIn>> getHabitCheckIns(String userId) async {
    final snapshot = await _collection(userId, 'habitCheckIns').get();
    return snapshot.docs
        .map((doc) => HabitCheckIn.fromJson(doc.data()))
        .toList();
  }

  // ── Write ─────────────────────────────────────────────────────

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
      collection: 'tasks',
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

  // ── Helpers ───────────────────────────────────────────────────

  CollectionReference<Map<String, dynamic>> _collection(
    String userId,
    String name,
  ) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection(name);
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

    await _collection(userId, collection).doc(id).set(
          data,
          SetOptions(merge: true),
        );
  }
}
