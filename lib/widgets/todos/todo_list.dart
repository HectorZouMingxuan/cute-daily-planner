import 'package:flutter/material.dart';

import '../../models/todo_item.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../common/empty_state.dart';
import '../common/soft_card.dart';
import 'todo_card.dart';

class TodoList extends StatelessWidget {
  const TodoList({
    required this.todos,
    required this.onToggle,
    required this.onDelete,
    this.onClearDone,
    super.key,
  });

  final List<TodoItem> todos;
  final ValueChanged<TodoItem> onToggle;
  final ValueChanged<TodoItem> onDelete;
  final VoidCallback? onClearDone;

  @override
  Widget build(BuildContext context) {
    final doneCount = todos.where((todo) => todo.isDone).length;
    final progress = todos.isEmpty ? 0.0 : doneCount / todos.length;

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        SoftCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$doneCount of ${todos.length} Done',
                style: TextStyle(
                  color: AppColors.textMain,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              LinearProgressIndicator(value: progress),
            ],
          ),
        ),
        if (onClearDone != null && doneCount > 0) ...[
          const SizedBox(height: AppSpacing.sm),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: onClearDone,
              icon: Icon(Icons.clear_all_rounded, size: 16),
              label: Text('Clear $doneCount done'),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.textMuted,
                textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
        const SizedBox(height: AppSpacing.md),
        if (todos.isEmpty)
          const SoftCard(
            child: EmptyState(
              icon: Icons.check_circle_outline_rounded,
              title: 'Today Tasks',
              message: 'No tasks yet',
            ),
          )
        else
          ...todos.map(
            (todo) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: TodoCard(
                todo: todo,
                onToggle: () => onToggle(todo),
                onDelete: () => onDelete(todo),
              ),
            ),
          ),
      ],
    );
  }
}
