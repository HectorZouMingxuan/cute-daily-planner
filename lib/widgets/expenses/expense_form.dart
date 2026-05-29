import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../models/expense_entry.dart';
import '../../models/sync_metadata.dart';
import '../../providers/user_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';

class ExpenseForm extends ConsumerStatefulWidget {
  const ExpenseForm({
    required this.selectedDate,
    required this.onSave,
    super.key,
    this.expense,
    this.onDelete,
  });

  final DateTime selectedDate;
  final ExpenseEntry? expense;
  final ValueChanged<ExpenseEntry> onSave;
  final ValueChanged<ExpenseEntry>? onDelete;

  @override
  ConsumerState<ExpenseForm> createState() => _ExpenseFormState();
}

class _ExpenseFormState extends ConsumerState<ExpenseForm> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  late ExpenseType _type;
  late ExpenseCategory _category;
  late PaymentMethod _paymentMethod;

  @override
  void initState() {
    super.initState();
    final expense = widget.expense;
    _amountController.text = expense == null ? '' : expense.amount.toString();
    _noteController.text = expense?.note ?? '';
    _type = expense?.type ?? ExpenseType.expense;
    _category = expense?.category ?? ExpenseCategory.food;
    _paymentMethod = expense?.paymentMethod ?? PaymentMethod.cash;
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final editing = widget.expense != null;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 12, 20, bottomInset + 20),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                editing ? 'Edit Expense' : 'Add Expense',
                style: AppTextStyles.title,
              ),
              const SizedBox(height: AppSpacing.md),
              SegmentedButton<ExpenseType>(
                segments: ExpenseType.values
                    .map(
                      (type) =>
                          ButtonSegment(value: type, label: Text(type.label)),
                    )
                    .toList(),
                selected: {_type},
                onSelectionChanged: (value) =>
                    setState(() => _type = value.first),
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(labelText: 'Amount'),
                validator: (value) {
                  final amount = double.tryParse(value ?? '');
                  if (amount == null || amount <= 0) {
                    return 'Amount must be greater than 0';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.sm),
              DropdownButtonFormField<ExpenseCategory>(
                initialValue: _category,
                decoration: const InputDecoration(labelText: 'Category'),
                items: ExpenseCategory.values
                    .map(
                      (category) => DropdownMenuItem(
                        value: category,
                        child: Text(category.label),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) setState(() => _category = value);
                },
              ),
              const SizedBox(height: AppSpacing.sm),
              DropdownButtonFormField<PaymentMethod>(
                initialValue: _paymentMethod,
                decoration: const InputDecoration(labelText: 'Payment Method'),
                items: PaymentMethod.values
                    .map(
                      (method) => DropdownMenuItem(
                        value: method,
                        child: Text(method.label),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) setState(() => _paymentMethod = value);
                },
              ),
              const SizedBox(height: AppSpacing.sm),
              TextFormField(
                controller: _noteController,
                decoration: const InputDecoration(labelText: 'Note'),
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  if (editing)
                    TextButton.icon(
                      onPressed: () => widget.onDelete?.call(widget.expense!),
                      icon: const Icon(Icons.delete_outline_rounded),
                      label: const Text('Delete'),
                    ),
                  const Spacer(),
                  FilledButton(onPressed: _save, child: const Text('Save')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final now = DateTime.now();
    final existing = widget.expense;
    final date = widget.selectedDate;
    widget.onSave(
      ExpenseEntry(
        id: existing?.id ?? const Uuid().v4(),
        userId: existing?.userId ?? ref.read(currentUserIdProvider),
        amount: double.parse(_amountController.text),
        type: _type,
        category: _category,
        note: _noteController.text.trim(),
        date: DateTime(date.year, date.month, date.day),
        paymentMethod: _paymentMethod,
        createdAt: existing?.createdAt ?? now,
        updatedAt: now,
        syncStatus: SyncStatus.localOnly,
        version: (existing?.version ?? 0) + 1,
      ),
    );
  }
}
