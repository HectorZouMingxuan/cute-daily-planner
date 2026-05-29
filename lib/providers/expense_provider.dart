import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/expense_entry.dart';
import '../repositories/expense_repository.dart';
import 'user_provider.dart';

final expenseRepositoryProvider = Provider<ExpenseRepository>((ref) {
  final api = ref.read(firestorePlannerApiProvider);
  return createExpenseRepository(firestoreApi: api);
});

final expenseListProvider =
    AsyncNotifierProvider<ExpenseListController, List<ExpenseEntry>>(
      ExpenseListController.new,
    );

class ExpenseListController extends AsyncNotifier<List<ExpenseEntry>> {
  ExpenseRepository get _repository => ref.read(expenseRepositoryProvider);

  @override
  Future<List<ExpenseEntry>> build() {
    final userId = ref.read(currentUserIdProvider);
    return _repository.getExpenses(userId: userId);
  }

  Future<void> refreshExpenses() async {
    final userId = ref.read(currentUserIdProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(
        () => _repository.getExpenses(userId: userId));
  }

  Future<void> saveExpense(ExpenseEntry expense) async {
    await _repository.saveExpense(expense);
    await refreshExpenses();
  }

  Future<void> deleteExpense(ExpenseEntry expense) async {
    await _repository.saveExpense(
      expense.copyWith(
        deletedAt: DateTime.now(),
        updatedAt: DateTime.now(),
        version: expense.version + 1,
      ),
    );
    await refreshExpenses();
  }
}
