import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/todo_item.dart';
import '../repositories/todo_repository.dart';
import 'user_provider.dart';

final todoRepositoryProvider = Provider<TodoRepository>((ref) {
  final api = ref.read(firestorePlannerApiProvider);
  return createTodoRepository(firestoreApi: api);
});

final todoListProvider =
    AsyncNotifierProvider<TodoListController, List<TodoItem>>(
      TodoListController.new,
    );

class TodoListController extends AsyncNotifier<List<TodoItem>> {
  TodoRepository get _repository => ref.read(todoRepositoryProvider);

  @override
  Future<List<TodoItem>> build() {
    final userId = ref.read(currentUserIdProvider);
    return _repository.getTodos(userId: userId);
  }

  Future<void> refreshTodos() async {
    final userId = ref.read(currentUserIdProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repository.getTodos(userId: userId));
  }

  Future<void> saveTodo(TodoItem todo) async {
    await _repository.saveTodo(todo);
    await refreshTodos();
  }

  Future<void> toggleDone(TodoItem todo) async {
    await saveTodo(
      todo.copyWith(
        isDone: !todo.isDone,
        updatedAt: DateTime.now(),
        version: todo.version + 1,
      ),
    );
  }

  Future<void> deleteTodo(TodoItem todo) async {
    await saveTodo(
      todo.copyWith(
        deletedAt: DateTime.now(),
        updatedAt: DateTime.now(),
        version: todo.version + 1,
      ),
    );
  }

  Future<void> clearDoneTodos(DateTime date) async {
    final todos = state.value ?? [];
    for (final todo in todos) {
      if (todo.isDone && _isSameDate(todo.date, date)) {
        await _repository.saveTodo(
          todo.copyWith(
            deletedAt: DateTime.now(),
            updatedAt: DateTime.now(),
            version: todo.version + 1,
          ),
        );
      }
    }
    await refreshTodos();
  }

  Future<void> restoreTodo(TodoItem todo) async {
    await _repository.saveTodo(TodoItem(
      id: todo.id,
      userId: todo.userId,
      title: todo.title,
      date: todo.date,
      isDone: todo.isDone,
      priority: todo.priority,
      createdAt: todo.createdAt,
      updatedAt: DateTime.now(),
      deletedAt: null,
      syncStatus: todo.syncStatus,
      version: todo.version + 1,
    ));
    await refreshTodos();
  }

  bool _isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
