import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../models/sync_metadata.dart';
import '../../models/todo_item.dart';
import '../../providers/user_provider.dart';
import '../../theme/app_spacing.dart';
import '../common/form_shell.dart';

class TodoForm extends ConsumerStatefulWidget {
  const TodoForm({required this.selectedDate, required this.onSave, super.key});

  final DateTime selectedDate;
  final ValueChanged<TodoItem> onSave;

  @override
  ConsumerState<TodoForm> createState() => _TodoFormState();
}

class _TodoFormState extends ConsumerState<TodoForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  TodoPriority _priority = TodoPriority.medium;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FormShell(
      title: 'Add Task',
      actions: Align(
        alignment: Alignment.centerRight,
        child: FilledButton(onPressed: _save, child: const Text('Save')),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Task title'),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Task title is required';
                }
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.md),
            DropdownButtonFormField<TodoPriority>(
              initialValue: _priority,
              decoration: const InputDecoration(labelText: 'Priority'),
              items: TodoPriority.values
                  .map(
                    (priority) => DropdownMenuItem(
                      value: priority,
                      child: Text(priority.label),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) setState(() => _priority = value);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final now = DateTime.now();
    final date = widget.selectedDate;
    widget.onSave(
      TodoItem(
        id: const Uuid().v4(),
        userId: ref.read(currentUserIdProvider),
        title: _titleController.text.trim(),
        date: DateTime(date.year, date.month, date.day),
        isDone: false,
        priority: _priority,
        createdAt: now,
        updatedAt: now,
        syncStatus: SyncStatus.localOnly,
        version: 1,
      ),
    );
  }
}
