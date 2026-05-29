import '../local/local_collection_store.dart';
import '../local/local_todo_dao.dart';
import '../models/todo_item.dart';
import '../remote/firestore_planner_api.dart';

class TodoRepository {
  TodoRepository(this._dao, {FirestorePlannerApi? firestoreApi})
      : _firestoreApi = firestoreApi;

  final LocalTodoDao _dao;
  final FirestorePlannerApi? _firestoreApi;

  Future<List<TodoItem>> getTodos({String userId = 'local-user'}) async {
    final api = _firestoreApi;
    if (api != null) {
      try {
        final remote = await api.getTodos(userId);
        for (final todo in remote) {
          await _dao.saveTodo(todo);
        }
        return remote;
      } catch (_) {}
    }
    return _dao.getTodos();
  }

  Future<void> saveTodo(TodoItem todo) async {
    await _dao.saveTodo(todo);

    final api = _firestoreApi;
    if (api != null) {
      try {
        await api.upsertTodo(todo);
      } catch (_) {}
    }
  }
}

TodoRepository createTodoRepository({FirestorePlannerApi? firestoreApi}) {
  return TodoRepository(
    LocalTodoDao(LocalCollectionStore('todos')),
    firestoreApi: firestoreApi,
  );
}
