import '../local/local_collection_store.dart';
import '../local/local_expense_dao.dart';
import '../models/expense_entry.dart';
import '../remote/firestore_planner_api.dart';

class ExpenseRepository {
  ExpenseRepository(this._dao, {FirestorePlannerApi? firestoreApi})
      : _firestoreApi = firestoreApi;

  final LocalExpenseDao _dao;
  final FirestorePlannerApi? _firestoreApi;

  Future<List<ExpenseEntry>> getExpenses({String userId = 'local-user'}) async {
    final api = _firestoreApi;
    if (api != null) {
      try {
        final remote = await api.getExpenses(userId);
        for (final expense in remote) {
          await _dao.saveExpense(expense);
        }
        return remote;
      } catch (_) {}
    }
    return _dao.getExpenses();
  }

  Future<void> saveExpense(ExpenseEntry expense) async {
    await _dao.saveExpense(expense);

    final api = _firestoreApi;
    if (api != null) {
      try {
        await api.upsertExpense(expense);
      } catch (_) {}
    }
  }
}

ExpenseRepository createExpenseRepository({FirestorePlannerApi? firestoreApi}) {
  return ExpenseRepository(
    LocalExpenseDao(LocalCollectionStore('expenses')),
    firestoreApi: firestoreApi,
  );
}
