import '../local/local_collection_store.dart';
import '../local/local_expense_dao.dart';
import '../models/expense_entry.dart';

class ExpenseRepository {
  ExpenseRepository(this._dao);

  final LocalExpenseDao _dao;

  Future<List<ExpenseEntry>> getExpenses() => _dao.getExpenses();

  Future<void> saveExpense(ExpenseEntry expense) => _dao.saveExpense(expense);
}

ExpenseRepository createExpenseRepository() {
  return ExpenseRepository(LocalExpenseDao(LocalCollectionStore('expenses')));
}
