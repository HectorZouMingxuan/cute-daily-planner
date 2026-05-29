import 'package:flutter/material.dart';

import '../../models/habit.dart';
import '../../models/habit_check_in.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
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
        final streak = _calculateStreak(habit.id, selectedDate);

        return Card(
          child: CheckboxListTile(
            value: done,
            onChanged: (_) => onToggle(habit, checkIn),
            title: Text(
              habit.title,
              style: TextStyle(
                color: AppColors.textMain,
                fontWeight: FontWeight.w800,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(done ? 'Done' : 'Not done'),
                    if (streak > 1) ...[
                      const SizedBox(width: AppSpacing.sm),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.mint.withValues(alpha: .25),
                          borderRadius: BorderRadius.circular(AppRadius.small),
                        ),
                        child: Text(
                          '$streak day streak',
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.mint),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                _WeekDots(habitId: habit.id, selectedDate: selectedDate, checkIns: checkIns),
              ],
            ),
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

  int _calculateStreak(String habitId, DateTime fromDate) {
    final doneDates = checkIns
        .where((c) => c.habitId == habitId && c.isDone)
        .map((c) => DateTime(c.date.year, c.date.month, c.date.day))
        .toSet();
    var streak = 0;
    var current = DateTime(fromDate.year, fromDate.month, fromDate.day);
    if (!doneDates.contains(current)) {
      current = current.subtract(const Duration(days: 1));
    }
    while (doneDates.contains(current)) {
      streak++;
      current = current.subtract(const Duration(days: 1));
    }
    return streak;
  }
}

class _WeekDots extends StatelessWidget {
  const _WeekDots({
    required this.habitId,
    required this.selectedDate,
    required this.checkIns,
  });

  final String habitId;
  final DateTime selectedDate;
  final List<HabitCheckIn> checkIns;

  @override
  Widget build(BuildContext context) {
    final monday = selectedDate.subtract(Duration(days: selectedDate.weekday - 1));
    final doneSet = checkIns
        .where((c) => c.habitId == habitId && c.isDone)
        .map((c) => DateTime(c.date.year, c.date.month, c.date.day))
        .toSet();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(7, (i) {
        final day = monday.add(Duration(days: i));
        final isDone = doneSet.contains(day);
        final isToday = _isSameDate(day, selectedDate);
        return Container(
          width: 10,
          height: 10,
          margin: const EdgeInsets.only(right: 3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isDone
                ? AppColors.mint.withValues(alpha: .75)
                : AppColors.border.withValues(alpha: .4),
            border: isToday && !isDone
                ? Border.all(color: AppColors.mint.withValues(alpha: .5), width: 1.5)
                : null,
          ),
        );
      }),
    );
  }

  bool _isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
