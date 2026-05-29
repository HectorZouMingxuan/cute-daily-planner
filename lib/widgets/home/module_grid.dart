import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import 'module_card.dart';

class ModuleGrid extends StatelessWidget {
  const ModuleGrid({
    required this.eventSubtitle,
    required this.expenseSubtitle,
    required this.taskSubtitle,
    required this.noteSubtitle,
    required this.moodSubtitle,
    required this.habitSubtitle,
    required this.onEventTap,
    required this.onExpenseTap,
    required this.onTaskTap,
    required this.onNoteTap,
    required this.onMoodTap,
    required this.onHabitTap,
    super.key,
  });

  final String eventSubtitle;
  final String expenseSubtitle;
  final String taskSubtitle;
  final String noteSubtitle;
  final String moodSubtitle;
  final String habitSubtitle;
  final VoidCallback onEventTap;
  final VoidCallback onExpenseTap;
  final VoidCallback onTaskTap;
  final VoidCallback onNoteTap;
  final VoidCallback onMoodTap;
  final VoidCallback onHabitTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = (constraints.maxWidth - AppSpacing.md) / 2;

        return Wrap(
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.md,
          children: [
            SizedBox(
              width: cardWidth,
              child: ModuleCard(
                icon: Icons.event_rounded,
                title: 'Events',
                color: AppColors.primary,
                subtitle: eventSubtitle,
                onTap: onEventTap,
              ),
            ),
            SizedBox(
              width: cardWidth,
              child: ModuleCard(
                icon: Icons.account_balance_wallet_rounded,
                title: 'Expenses',
                color: AppColors.yellow,
                subtitle: expenseSubtitle,
                onTap: onExpenseTap,
              ),
            ),
            SizedBox(
              width: cardWidth,
              child: ModuleCard(
                icon: Icons.checklist_rounded,
                title: 'Tasks',
                color: AppColors.sage,
                subtitle: taskSubtitle,
                onTap: onTaskTap,
              ),
            ),
            SizedBox(
              width: cardWidth,
              child: ModuleCard(
                icon: Icons.edit_note_rounded,
                title: 'Notes',
                color: AppColors.lavender,
                subtitle: noteSubtitle,
                onTap: onNoteTap,
              ),
            ),
            SizedBox(
              width: cardWidth,
              child: ModuleCard(
                icon: Icons.sentiment_satisfied_alt_rounded,
                title: 'Mood',
                color: AppColors.pink,
                subtitle: moodSubtitle,
                onTap: onMoodTap,
              ),
            ),
            SizedBox(
              width: cardWidth,
              child: ModuleCard(
                icon: Icons.auto_awesome_rounded,
                title: 'Habits',
                color: AppColors.mint,
                subtitle: habitSubtitle,
                onTap: onHabitTap,
              ),
            ),
          ],
        );
      },
    );
  }
}
