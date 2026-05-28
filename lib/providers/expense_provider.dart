import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/expense_entry.dart';
import '../repositories/expense_repository.dart';

final expenseRepositoryProvider = Provider<ExpenseRepository>((ref) {
  return createExpenseRepository();
});

final expenseListProvider =
    AsyncNotifierProvider<ExpenseListController, List<ExpenseEntry>>(
      ExpenseListController.new,
    );

class ExpenseListController extends AsyncNotifier<List<ExpenseEntry>> {
  ExpenseRepository get _repository => ref.read(expenseRepositoryProvider);

  @override
  Future<List<ExpenseEntry>> build() => _repository.getExpenses();

  Future<void> saveExpense(ExpenseEntry expense) async {
    await _repository.saveExpense(expense);
    state = await AsyncValue.guard(_repository.getExpenses);
  }

  Future<void> deleteExpense(ExpenseEntry expense) async {
    await _repository.saveExpense(
      expense.copyWith(
        deletedAt: DateTime.now(),
        updatedAt: DateTime.now(),
        version: expense.version + 1,
      ),
    );
    state = await AsyncValue.guard(_repository.getExpenses);
  }
}
