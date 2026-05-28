import 'package:flutter/material.dart';

import '../../models/habit.dart';
import '../../models/habit_check_in.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../common/empty_state.dart';
import '../common/soft_card.dart';

class HabitCheckList extends StatelessWidget {
  const HabitCheckList({
    required this.habits,
    required this.checkIns,
    required this.selectedDate,
    required this.onToggle,
    super.key,
  });

  final List<Habit> habits;
  final List<HabitCheckIn> checkIns;
  final DateTime selectedDate;
  final void Function(Habit habit, HabitCheckIn? checkIn) onToggle;

  @override
  Widget build(BuildContext context) {
    if (habits.isEmpty) {
      return const SoftCard(
        child: EmptyState(
          icon: Icons.auto_awesome_outlined,
          title: 'Habits',
          message: 'Add a small routine',
        ),
      );
    }

    return Column(
      children: habits.map((habit) {
        final checkIn = checkIns.where((item) {
          return item.habitId == habit.id &&
              _isSameDate(item.date, selectedDate);
        }).firstOrNull;
        final done = checkIn?.isDone ?? false;

        return Card(
          child: CheckboxListTile(
            value: done,
            onChanged: (_) => onToggle(habit, checkIn),
            title: Text(
              habit.title,
              style: const TextStyle(
                color: AppColors.textMain,
                fontWeight: FontWeight.w800,
              ),
            ),
            subtitle: Text(done ? 'Done' : 'Not Done'),
            secondary: CircleAvatar(
              backgroundColor: Color(habit.color).withValues(alpha: .45),
              child: const Icon(Icons.check_rounded),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
            ),
          ),
        );
      }).toList(),
    );
  }

  bool _isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
