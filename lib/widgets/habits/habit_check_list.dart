import 'package:flutter/material.dart';

import '../../models/habit.dart';
import '../../models/habit_check_in.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_date_utils.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../common/empty_state.dart';
import '../common/planner_card.dart';

const _habitIcons = {
  'check': Icons.check_rounded,
  'star': Icons.star_rounded,
  'heart': Icons.favorite_rounded,
  'bolt': Icons.bolt_rounded,
  'flame': Icons.local_fire_department_rounded,
  'book': Icons.menu_book_rounded,
};

class HabitCheckList extends StatelessWidget {
  const HabitCheckList({
    required this.habits,
    required this.checkIns,
    required this.selectedDate,
    required this.onToggle,
    required this.onDelete,
    super.key,
  });

  final List<Habit> habits;
  final List<HabitCheckIn> checkIns;
  final DateTime selectedDate;
  final void Function(Habit habit, HabitCheckIn? checkIn) onToggle;
  final ValueChanged<Habit> onDelete;

  @override
  Widget build(BuildContext context) {
    if (habits.isEmpty) {
      return const EmptyState(
        icon: Icons.auto_awesome_outlined,
        title: 'Habits',
        message: 'Add a small routine',
      );
    }

    final allDone = habits.every((h) {
      final ci = checkIns
          .where((c) =>
              c.habitId == h.id &&
              AppDateUtils.isSameDate(c.date, selectedDate))
          .firstOrNull;
      return ci?.isDone ?? false;
    });

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...habits.map((habit) {
          final checkIn = checkIns
              .where((item) =>
                  item.habitId == habit.id &&
                  AppDateUtils.isSameDate(item.date, selectedDate))
              .firstOrNull;
          final done = checkIn?.isDone ?? false;
          final streak = _calculateStreak(habit.id, selectedDate);
          final habitColor = Color(habit.color);

          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: Dismissible(
              key: Key(habit.id),
              direction: DismissDirection.endToStart,
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: AppSpacing.lg),
                decoration: BoxDecoration(
                  color: AppColors.danger.withValues(alpha: .85),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: const Icon(Icons.delete_rounded, color: Colors.white),
              ),
              confirmDismiss: (_) async {
                onDelete(habit);
                return false;
              },
              child: PlannerCard(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm + 4,
                  vertical: AppSpacing.sm,
                ),
                borderColor: done
                    ? habitColor.withValues(alpha: .35)
                    : null,
                child: Row(
                  children: [
                    // Habit icon
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: habitColor.withValues(alpha: .3),
                      child: Icon(
                        _habitIcons[habit.icon] ?? Icons.check_rounded,
                        size: 18,
                        color: habitColor,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm + 4),
                    // Title + streak + week dots
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  habit.title,
                                  style: TextStyle(
                                    color: done
                                        ? AppColors.textMuted
                                        : AppColors.textMain,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 14,
                                    decoration: done
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,
                                  ),
                                ),
                              ),
                              if (streak > 1)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: habitColor.withValues(alpha: .2),
                                    borderRadius:
                                        BorderRadius.circular(AppRadius.xs),
                                  ),
                                  child: Text(
                                    '$streak day streak',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: habitColor,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            done ? 'Done ✓' : 'Tap to complete',
                            style: TextStyle(
                              fontSize: 11,
                              color: done
                                  ? AppColors.mint
                                  : AppColors.textMuted,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          _WeekDots(
                            habitId: habit.id,
                            selectedDate: selectedDate,
                            checkIns: checkIns,
                            color: habitColor,
                          ),
                        ],
                      ),
                    ),
                    // Checkbox
                    SizedBox(
                      width: 28,
                      height: 28,
                      child: Checkbox(
                        value: done,
                        onChanged: (_) => onToggle(habit, checkIn),
                        fillColor: WidgetStateProperty.resolveWith((states) {
                          if (states.contains(WidgetState.selected)) {
                            return habitColor;
                          }
                          return null;
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
        if (allDone) ...[
          const SizedBox(height: AppSpacing.md),
          Text(
            'All habits checked in today! 🎉',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.mint,
            ),
          ),
        ],
      ],
    );
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
    required this.color,
  });

  final String habitId;
  final DateTime selectedDate;
  final List<HabitCheckIn> checkIns;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final monday =
        selectedDate.subtract(Duration(days: selectedDate.weekday - 1));
    final doneSet = checkIns
        .where((c) => c.habitId == habitId && c.isDone)
        .map((c) => DateTime(c.date.year, c.date.month, c.date.day))
        .toSet();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(7, (i) {
        final day = monday.add(Duration(days: i));
        final isDone = doneSet.contains(day);
        final isToday = AppDateUtils.isSameDate(day, selectedDate);
        return Container(
          width: 10,
          height: 10,
          margin: const EdgeInsets.only(right: 3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isDone
                ? color.withValues(alpha: .75)
                : AppColors.border.withValues(alpha: .35),
            border: isToday && !isDone
                ? Border.all(color: color.withValues(alpha: .5), width: 1.5)
                : null,
          ),
        );
      }),
    );
  }
}
