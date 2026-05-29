import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/todo_item.dart';
import '../../providers/todo_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_date_utils.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../common/empty_state.dart';
import '../common/soft_card.dart';
import 'todo_card.dart';

class _PriorityCount extends StatelessWidget {
  const _PriorityCount({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .18),
        borderRadius: BorderRadius.circular(AppRadius.small),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: color),
      ),
    );
  }
}

class TodoList extends ConsumerWidget {
  const TodoList({
    required this.selectedDate,
    required this.onToggle,
    required this.onDelete,
    this.onClearDone,
    super.key,
  });

  final DateTime selectedDate;
  final ValueChanged<TodoItem> onToggle;
  final ValueChanged<TodoItem> onDelete;
  final VoidCallback? onClearDone;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allTodos = ref.watch(todoListProvider).value ?? [];
    final todos = allTodos
        .where((t) => AppDateUtils.isSameDate(t.date, selectedDate))
        .toList();

    final doneCount = todos.where((todo) => todo.isDone).length;
    final progress = todos.isEmpty ? 0.0 : doneCount / todos.length;
    final highCount = todos.where((t) => t.priority == TodoPriority.high).length;
    final mediumCount = todos.where((t) => t.priority == TodoPriority.medium).length;
    final lowCount = todos.where((t) => t.priority == TodoPriority.low).length;

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
              if (todos.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    if (highCount > 0) _PriorityCount(label: '$highCount high', color: AppColors.pink),
                    if (mediumCount > 0) _PriorityCount(label: '$mediumCount med', color: AppColors.yellow),
                    if (lowCount > 0) _PriorityCount(label: '$lowCount low', color: AppColors.mint),
                  ].map((w) => Padding(padding: const EdgeInsets.only(right: AppSpacing.sm), child: w)).toList(),
                ),
              ],
            ],
          ),
        ),
        if (onClearDone != null && doneCount > 0) ...[
          const SizedBox(height: AppSpacing.sm),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Clear Done Tasks'),
                    content: Text(
                      'Remove all $doneCount completed tasks? This cannot be undone.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                          onClearDone?.call();
                        },
                        child: const Text('Clear',
                            style: TextStyle(color: AppColors.danger)),
                      ),
                    ],
                  ),
                );
              },
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
        else if (doneCount == todos.length)
          const SoftCard(
            child: EmptyState(
              icon: Icons.celebration_outlined,
              title: 'All done!',
              message: 'Every task is complete — great work!',
            ),
          )
        else
          ...todos.map(
            (todo) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Dismissible(
                key: Key(todo.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.danger.withValues(alpha: .85),
                    borderRadius: BorderRadius.circular(AppRadius.medium),
                  ),
                  child: const Icon(Icons.delete_rounded, color: Colors.white, size: 20),
                ),
                onDismissed: (_) => onDelete(todo),
                child: TodoCard(
                  todo: todo,
                  onToggle: () => onToggle(todo),
                  onDelete: () => onDelete(todo),
                ),
              ),
            ),
          ),
      ],
    );
  }

}
