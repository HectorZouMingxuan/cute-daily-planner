import '../local/local_collection_store.dart';
import '../local/local_todo_dao.dart';
import '../models/todo_item.dart';

class TodoRepository {
  TodoRepository(this._dao);

  final LocalTodoDao _dao;

  Future<List<TodoItem>> getTodos() => _dao.getTodos();

  Future<void> saveTodo(TodoItem todo) => _dao.saveTodo(todo);
}

TodoRepository createTodoRepository() {
  return TodoRepository(LocalTodoDao(LocalCollectionStore('todos')));
}
