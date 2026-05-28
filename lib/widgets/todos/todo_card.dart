import 'package:flutter/material.dart';

import '../../models/todo_item.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';

class TodoCard extends StatelessWidget {
  const TodoCard({
    required this.todo,
    required this.onToggle,
    required this.onDelete,
    super.key,
  });

  final TodoItem todo;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final color = switch (todo.priority) {
      TodoPriority.low => AppColors.mint,
      TodoPriority.medium => AppColors.yellow,
      TodoPriority.high => AppColors.pink,
    };

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Row(
          children: [
            Checkbox(value: todo.isDone, onChanged: (_) => onToggle()),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    todo.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.textMain,
                      fontWeight: FontWeight.w800,
                      decoration: todo.isDone
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: .45),
                      borderRadius: BorderRadius.circular(AppRadius.small),
                    ),
                    child: Text(
                      todo.priority.label,
                      style: const TextStyle(
                        color: AppColors.textMain,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              tooltip: 'Delete',
              onPressed: onDelete,
              icon: const Icon(Icons.delete_outline_rounded),
            ),
          ],
        ),
      ),
    );
  }
}
