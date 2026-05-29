import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../models/habit.dart';
import '../../models/sync_metadata.dart';
import '../../providers/user_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../common/form_shell.dart';

class HabitForm extends ConsumerStatefulWidget {
  const HabitForm({required this.onSave, super.key});

  final ValueChanged<Habit> onSave;

  @override
  ConsumerState<HabitForm> createState() => _HabitFormState();
}

class _HabitFormState extends ConsumerState<HabitForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  String _selectedIcon = 'check';
  Color _selectedColor = AppColors.mint;

  static const _iconOptions = {
    'check': Icons.check_rounded,
    'star': Icons.star_rounded,
    'heart': Icons.favorite_rounded,
    'bolt': Icons.bolt_rounded,
    'flame': Icons.local_fire_department_rounded,
    'book': Icons.menu_book_rounded,
  };

  static final _colorOptions = [
    AppColors.mint,
    AppColors.sage,
    AppColors.pink,
    AppColors.lavender,
    AppColors.yellow,
    AppColors.primary,
  ];

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FormShell(
      title: 'Add Habit',
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
              decoration: const InputDecoration(labelText: 'Habit title'),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Habit title is required';
                }
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.md),
            Text('Icon', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              children: _iconOptions.entries.map((entry) {
                final selected = _selectedIcon == entry.key;
                return GestureDetector(
                  onTap: () => setState(() => _selectedIcon = entry.key),
                  child: CircleAvatar(
                    backgroundColor: selected
                        ? AppColors.primary.withValues(alpha: .3)
                        : AppColors.surface,
                    child: Icon(entry.value,
                        size: 20,
                        color: selected ? AppColors.primary : AppColors.textMain),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: AppSpacing.md),
            Text('Color', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              children: _colorOptions.map((color) {
                final selected = _selectedColor == color;
                return GestureDetector(
                  onTap: () => setState(() => _selectedColor = color),
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: .45),
                      shape: BoxShape.circle,
                      border: selected
                          ? Border.all(color: color, width: 2.5)
                          : null,
                    ),
                  ),
                );
              }).toList(),
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
        userId: ref.read(currentUserIdProvider),
        title: _titleController.text.trim(),
        icon: _selectedIcon,
        color: _selectedColor.toARGB32(),
        createdAt: now,
        updatedAt: now,
        syncStatus: SyncStatus.localOnly,
        version: 1,
      ),
    );
  }
}
