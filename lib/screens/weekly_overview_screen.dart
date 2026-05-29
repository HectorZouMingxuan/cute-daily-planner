import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../models/expense_entry.dart';
import '../models/mood_entry.dart';
import '../providers/calendar_view_provider.dart';
import '../providers/event_provider.dart';
import '../providers/expense_provider.dart';
import '../providers/habit_provider.dart';
import '../providers/mood_provider.dart';
import '../providers/todo_provider.dart';
import '../recurrence/recurrence_calculator.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import '../widgets/common/soft_card.dart';

class WeeklyOverviewScreen extends ConsumerWidget {
  const WeeklyOverviewScreen({super.key});

  static const _recurrenceCalculator = RecurrenceCalculator();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventList = ref.watch(eventListProvider);
    final expenseList = ref.watch(expenseListProvider);
    final todoList = ref.watch(todoListProvider);
    final moodList = ref.watch(moodListProvider);
    final habitState = ref.watch(habitProvider);
    final calendarView = ref.watch(calendarViewProvider);

    final today = calendarView.selectedDay;
    final weekStart = today.subtract(Duration(days: today.weekday - 1));
    final weekEnd = weekStart.add(const Duration(days: 6));
    final weekRange = '${DateFormat('MMM d').format(weekStart)} — ${DateFormat('MMM d, yyyy').format(weekEnd)}';

    final events = eventList.value ?? const [];
    final expenses = expenseList.value ?? const [];
    final todos = todoList.value ?? const [];
    final moods = moodList.value ?? const [];
    final habits = habitState.valueOrNullForUi.habits;
    final checkIns = habitState.valueOrNullForUi.checkIns;

    // Aggregate stats
    var totalTasksDone = 0;
    var totalTasks = 0;
    var totalIncome = 0.0;
    var totalSpending = 0.0;
    var totalEvents = 0;
    final moodCounts = <MoodOption, int>{};
    var habitDaysChecked = 0;
    var habitTotalDays = habits.length * 7;

    // Day-by-day data
    final dailyCards = List.generate(7, (i) {
      final day = weekStart.add(Duration(days: i));

      final dayEvents = events
          .where((e) => _recurrenceCalculator.occursOn(e, day))
          .length;
      totalEvents += dayEvents;

      final dayExpenses = expenses
          .where((e) => _isSameDate(e.date, day))
          .toList();
      for (final e in dayExpenses) {
        if (e.type == ExpenseType.income) {
          totalIncome += e.amount;
        } else {
          totalSpending += e.amount;
        }
      }

      final dayTodos = todos
          .where((t) => _isSameDate(t.date, day))
          .toList();
      totalTasks += dayTodos.length;
      totalTasksDone += dayTodos.where((t) => t.isDone).length;

      final dayMood = moods
          .where((m) => _isSameDate(m.date, day))
          .firstOrNull;
      if (dayMood != null) {
        moodCounts[dayMood.mood] = (moodCounts[dayMood.mood] ?? 0) + 1;
      }

      final dayCheckIns = checkIns
          .where((c) => _isSameDate(c.date, day) && c.isDone)
          .length;
      habitDaysChecked += dayCheckIns;

      return _DayRow(
        day: day,
        isToday: _isSameDate(day, today),
        eventCount: dayEvents,
        expenseDay: dayExpenses,
        todoDone: dayTodos.where((t) => t.isDone).length,
        todoTotal: dayTodos.length,
        mood: dayMood?.mood,
        habitsChecked: dayCheckIns,
        habitsTotal: habits.length,
      );
    });

    final avgMood = moodCounts.entries.isEmpty
        ? null
        : moodCounts.entries.reduce((a, b) => a.value > b.value ? a : b).key;

    return Scaffold(
      appBar: AppBar(
        title: Text('Week', style: const TextStyle(fontSize: 16)),
        backgroundColor: AppColors.ink.withValues(alpha: .72),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.primarySoft.withValues(alpha: .18),
                ),
              ),
            ),
            ListView(
              padding: const EdgeInsets.all(AppSpacing.md),
              children: [
                Text(weekRange, style: AppTextStyles.sectionTitle),
                const SizedBox(height: AppSpacing.md),
                // Aggregate summary row
                SoftCard(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Wrap(
                    spacing: AppSpacing.md,
                    runSpacing: AppSpacing.sm,
                    children: [
                      _AggregateChip(
                        icon: Icons.checklist_rounded,
                        label: '$totalTasksDone / $totalTasks tasks done',
                        color: AppColors.sage,
                      ),
                      _AggregateChip(
                        icon: Icons.account_balance_wallet_rounded,
                        label:
                            '+${totalIncome.toStringAsFixed(0)}  -${totalSpending.toStringAsFixed(0)}',
                        color: totalIncome > totalSpending
                            ? AppColors.mint
                            : AppColors.danger,
                      ),
                      _AggregateChip(
                        icon: Icons.event_rounded,
                        label: '$totalEvents events',
                        color: AppColors.primary,
                      ),
                      if (avgMood != null)
                        _AggregateChip(
                          icon: Icons.sentiment_satisfied_alt_rounded,
                          label: 'Mostly ${avgMood.label}',
                          color: AppColors.pink,
                        ),
                      _AggregateChip(
                        icon: Icons.auto_awesome_rounded,
                        label: '$habitDaysChecked / $habitTotalDays habits',
                        color: AppColors.mint,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text('Daily Breakdown', style: AppTextStyles.sectionTitle),
                const SizedBox(height: AppSpacing.sm),
                ...dailyCards,
              ],
            ),
          ],
        ),
      ),
    );
  }

  bool _isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

class _AggregateChip extends StatelessWidget {
  const _AggregateChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .15),
        borderRadius: BorderRadius.circular(AppRadius.small),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: color),
          ),
        ],
      ),
    );
  }
}

class _DayRow extends StatelessWidget {
  const _DayRow({
    required this.day,
    required this.isToday,
    required this.eventCount,
    required this.expenseDay,
    required this.todoDone,
    required this.todoTotal,
    required this.mood,
    required this.habitsChecked,
    required this.habitsTotal,
  });

  final DateTime day;
  final bool isToday;
  final int eventCount;
  final List<ExpenseEntry> expenseDay;
  final int todoDone;
  final int todoTotal;
  final MoodOption? mood;
  final int habitsChecked;
  final int habitsTotal;

  static const _moji = {
    MoodOption.great: '🌟',
    MoodOption.good: '☀️',
    MoodOption.okay: '🍃',
    MoodOption.tired: '🌙',
    MoodOption.bad: '☁️',
  };

  @override
  Widget build(BuildContext context) {
    final dayLabel = DateFormat('EEE').format(day);
    final dateLabel = DateFormat('MMM d').format(day);

    final net = expenseDay.fold<double>(
      0,
      (sum, e) => e.type == ExpenseType.income ? sum + e.amount : sum - e.amount,
    );

    return Card(
      color: isToday ? AppColors.primarySoft.withValues(alpha: .55) : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.medium),
        side: isToday
            ? const BorderSide(color: AppColors.primary, width: 1.5)
            : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm + 4),
        child: Row(
          children: [
            SizedBox(
              width: 52,
              child: Column(
                children: [
                  Text(
                    dayLabel,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: isToday ? AppColors.primary : AppColors.textMain,
                    ),
                  ),
                  Text(
                    dateLabel,
                    style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Wrap(
                spacing: 6,
                runSpacing: 4,
                children: [
                  if (mood != null)
                    Text(_moji[mood] ?? '', style: const TextStyle(fontSize: 16)),
                  if (eventCount > 0)
                    _MiniChip(label: '$eventCount ev', color: AppColors.primary),
                  if (todoTotal > 0)
                    _MiniChip(
                      label: todoDone == todoTotal ? 'All done' : '$todoDone/$todoTotal',
                      color: AppColors.sage,
                    ),
                  if (net != 0)
                    _MiniChip(
                      label: '${net > 0 ? "+" : ""}${net.toStringAsFixed(0)}',
                      color: net > 0 ? AppColors.mint : AppColors.danger,
                    ),
                  if (habitsTotal > 0 && habitsChecked > 0)
                    _MiniChip(
                      label: '$habitsChecked/$habitsTotal hab',
                      color: AppColors.mint,
                    ),
                  if (mood == null && eventCount == 0 && todoTotal == 0 && net == 0 && habitsChecked == 0)
                    const Text(
                      'No data',
                      style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniChip extends StatelessWidget {
  const _MiniChip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .18),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: color),
      ),
    );
  }
}

extension _HabitStateValue on AsyncValue<HabitState> {
  HabitState get valueOrNullForUi {
    return switch (this) {
      AsyncData(:final value) => value,
      _ => const HabitState(habits: [], checkIns: []),
    };
  }
}
