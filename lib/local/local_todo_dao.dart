import '../models/todo_item.dart';
import 'local_collection_store.dart';

class LocalTodoDao {
  LocalTodoDao(this._store);

  final LocalCollectionStore _store;

  Future<List<TodoItem>> getTodos() async {
    final items = await _store.getAll();
    return items
        .map(TodoItem.fromJson)
        .where((todo) => !todo.isDeleted)
        .toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
  }

  Future<void> saveTodo(TodoItem todo) {
    return _store.put(todo.id, todo.toJson());
  }
}
