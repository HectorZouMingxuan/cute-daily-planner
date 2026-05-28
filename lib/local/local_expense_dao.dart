import '../models/expense_entry.dart';
import 'local_collection_store.dart';

class LocalExpenseDao {
  LocalExpenseDao(this._store);

  final LocalCollectionStore _store;

  Future<List<ExpenseEntry>> getExpenses() async {
    final items = await _store.getAll();
    return items
        .map(ExpenseEntry.fromJson)
        .where((entry) => !entry.isDeleted)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  Future<void> saveExpense(ExpenseEntry expense) {
    return _store.put(expense.id, expense.toJson());
  }
}
