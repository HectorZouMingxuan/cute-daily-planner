import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/todo_item.dart';
import '../../providers/todo_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_date_utils.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';
import '../common/empty_state.dart';
import '../common/planner_card.dart';
import 'todo_card.dart';

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
    final highCount =
        todos.where((t) => t.priority == TodoPriority.high).length;
    final mediumCount =
        todos.where((t) => t.priority == TodoPriority.medium).length;
    final lowCount =
        todos.where((t) => t.priority == TodoPriority.low).length;

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenH,
        0,
        AppSpacing.screenH,
        AppSpacing.screenH,
      ),
      children: [
        // Progress card
        PlannerCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '$doneCount of ${todos.length} Done',
                      style: AppTextStyles.subheading,
                    ),
                  ),
                  Text(
                    '${(progress * 100).round()}%',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 6,
                  backgroundColor: AppColors.border.withValues(alpha: .35),
                  color: progress >= 1 ? AppColors.mint : AppColors.primary,
                ),
              ),
              if (todos.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.sm + 4),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.xs,
                  children: [
                    if (highCount > 0)
                      _Pill(label: '$highCount high', color: AppColors.priorityHigh),
                    if (mediumCount > 0)
                      _Pill(label: '$mediumCount med', color: AppColors.priorityMedium),
                    if (lowCount > 0)
                      _Pill(label: '$lowCount low', color: AppColors.priorityLow),
                  ],
                ),
              ],
            ],
          ),
        ),
        // Clear done button
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
              icon: const Icon(Icons.clear_all_rounded, size: 16),
              label: Text('Clear $doneCount done'),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.textMuted,
                textStyle:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
        const SizedBox(height: AppSpacing.cardGap),
        // Task list or empty state
        if (todos.isEmpty)
          const EmptyState(
            icon: Icons.check_circle_outline_rounded,
            title: 'Today Tasks',
            message: 'No tasks yet',
          )
        else if (doneCount == todos.length)
          const EmptyState(
            icon: Icons.celebration_outlined,
            title: 'All done!',
            message: 'Every task is complete — great work!',
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
                  padding: const EdgeInsets.only(right: AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: AppColors.danger.withValues(alpha: .85),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: const Icon(Icons.delete_rounded,
                      color: Colors.white, size: 22),
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

class _Pill extends StatelessWidget {
  const _Pill({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .18),
        borderRadius: BorderRadius.circular(AppRadius.xs),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}
