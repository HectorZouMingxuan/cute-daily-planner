import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../models/habit.dart';
import '../../models/sync_metadata.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';

class HabitForm extends StatefulWidget {
  const HabitForm({required this.onSave, super.key});

  final ValueChanged<Habit> onSave;

  @override
  State<HabitForm> createState() => _HabitFormState();
}

class _HabitFormState extends State<HabitForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 12, 20, bottomInset + 20),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Add Habit', style: AppTextStyles.title),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Habit title'),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Habit title is required';
                }
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.lg),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton(onPressed: _save, child: const Text('Save')),
            ),
          ],
        ),
      ),
    );
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final now = DateTime.now();
    widget.onSave(
      Habit(
        id: const Uuid().v4(),
        userId: 'local-user',
        title: _titleController.text.trim(),
        icon: 'check',
        color: AppColors.mint.toARGB32(),
        createdAt: now,
        updatedAt: now,
        syncStatus: SyncStatus.localOnly,
        version: 1,
      ),
    );
  }
}
