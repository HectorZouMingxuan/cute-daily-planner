import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/todo_item.dart';
import '../repositories/todo_repository.dart';

final todoRepositoryProvider = Provider<TodoRepository>((ref) {
  return createTodoRepository();
});

final todoListProvider =
    AsyncNotifierProvider<TodoListController, List<TodoItem>>(
      TodoListController.new,
    );

class TodoListController extends AsyncNotifier<List<TodoItem>> {
  TodoRepository get _repository => ref.read(todoRepositoryProvider);

  @override
  Future<List<TodoItem>> build() => _repository.getTodos();

  Future<void> saveTodo(TodoItem todo) async {
    await _repository.saveTodo(todo);
    state = await AsyncValue.guard(_repository.getTodos);
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
}
