import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../models/expense_entry.dart';
import '../models/mood_entry.dart';
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

class WeeklyOverviewScreen extends ConsumerStatefulWidget {
  const WeeklyOverviewScreen({super.key});

  @override
  ConsumerState<WeeklyOverviewScreen> createState() => _WeeklyOverviewScreenState();
}

class _WeeklyOverviewScreenState extends ConsumerState<WeeklyOverviewScreen> {
  static const _recurrenceCalculator = RecurrenceCalculator();
  int _weekOffset = 0;

  @override
  Widget build(BuildContext context) {
    final eventList = ref.watch(eventListProvider);
    final expenseList = ref.watch(expenseListProvider);
    final todoList = ref.watch(todoListProvider);
    final moodList = ref.watch(moodListProvider);
    final habitState = ref.watch(habitProvider);

    final today = DateTime.now();
    final monday = today.subtract(Duration(days: today.weekday - 1));
    final weekStart = monday.add(Duration(days: _weekOffset * 7));
    final weekEnd = weekStart.add(const Duration(days: 6));
    final weekRange = '${DateFormat('MMM d').format(weekStart)} — ${DateFormat('MMM d, yyyy').format(weekEnd)}';
    final isCurrentWeek = _weekOffset == 0;

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

    // Previous week comparison
    final prevWeekStart = weekStart.subtract(const Duration(days: 7));
    int prevTasksDone = 0;
    double prevIncome = 0;
    double prevSpending = 0;
    int prevEvents = 0;
    int prevHabitsChecked = 0;
    for (int i = 0; i < 7; i++) {
      final day = prevWeekStart.add(Duration(days: i));
      prevEvents += events.where((e) => _recurrenceCalculator.occursOn(e, day)).length;
      final dayExpenses = expenses.where((e) => _isSameDate(e.date, day)).toList();
      for (final e in dayExpenses) {
        if (e.type == ExpenseType.income) {
          prevIncome += e.amount;
        } else {
          prevSpending += e.amount;
        }
      }
      final dayTodos = todos.where((t) => _isSameDate(t.date, day)).toList();
      prevTasksDone += dayTodos.where((t) => t.isDone).length;
      prevHabitsChecked += checkIns.where((c) => _isSameDate(c.date, day) && c.isDone).length;
    }

    final avgMood = moodCounts.entries.isEmpty
        ? null
        : moodCounts.entries.reduce((a, b) => a.value > b.value ? a : b).key;

    // Category breakdown for the week
    final weekExpenses = expenses.where((e) {
      final d = DateTime(e.date.year, e.date.month, e.date.day);
      return !d.isBefore(weekStart) && !d.isAfter(weekEnd) && e.type == ExpenseType.expense;
    }).toList();
    final categoryTotals = <ExpenseCategory, double>{};
    for (final e in weekExpenses) {
      categoryTotals[e.category] = (categoryTotals[e.category] ?? 0) + e.amount;
    }
    final sortedCategories = categoryTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final hasCategories = sortedCategories.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text('Week', style: TextStyle(fontSize: 16)),
        backgroundColor: AppColors.ink.withValues(alpha: .72),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            tooltip: 'Previous week',
            onPressed: () => setState(() => _weekOffset--),
            icon: Icon(Icons.chevron_left_rounded),
          ),
          if (!isCurrentWeek)
            IconButton(
              tooltip: 'Back to current week',
              onPressed: () => setState(() => _weekOffset = 0),
              icon: const Icon(Icons.today_outlined),
            ),
          IconButton(
            tooltip: 'Next week',
            onPressed: () => setState(() => _weekOffset++),
            icon: const Icon(Icons.chevron_right_rounded),
          ),
        ],
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
                const SizedBox(height: AppSpacing.sm),
                Text(
                  _narrativeSummary(totalTasksDone, totalTasks, totalIncome, totalSpending, avgMood, habitDaysChecked, habitTotalDays, totalEvents),
                  style:  TextStyle(fontSize: 13, color: AppColors.textMuted, fontWeight: FontWeight.w500, height: 1.4),
                ),
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
                        delta: _deltaStr(totalTasksDone - prevTasksDone),
                      ),
                      _AggregateChip(
                        icon: Icons.account_balance_wallet_rounded,
                        label:
                            '+${totalIncome.toStringAsFixed(0)}  -${totalSpending.toStringAsFixed(0)}',
                        color: totalIncome > totalSpending
                            ? AppColors.mint
                            : AppColors.danger,
                        delta: _deltaStr(
                          (totalIncome - totalSpending - (prevIncome - prevSpending)).round(),
                        ),
                      ),
                      _AggregateChip(
                        icon: Icons.event_rounded,
                        label: '$totalEvents events',
                        color: AppColors.primary,
                        delta: _deltaStr(totalEvents - prevEvents),
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
                        delta: _deltaStr(habitDaysChecked - prevHabitsChecked),
                      ),
                    ],
                  ),
                ),
                if (moodCounts.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.sm),
                  _MoodDistributionRow(moodCounts: moodCounts),
                ],
                const SizedBox(height: AppSpacing.md),
                Text('Daily Breakdown', style: AppTextStyles.sectionTitle),
                const SizedBox(height: AppSpacing.sm),
                ...dailyCards,
                if (hasCategories) ...[
                  const SizedBox(height: AppSpacing.md),
                  Text('Spending by Category', style: AppTextStyles.sectionTitle),
                  const SizedBox(height: AppSpacing.sm),
                  SoftCard(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      children: sortedCategories.map((entry) {
                        final maxAmount = sortedCategories.first.value;
                        final ratio = maxAmount > 0 ? entry.value / maxAmount : 1.0;
                        return _CategoryBar(
                          category: entry.key,
                          amount: entry.value,
                          ratio: ratio,
                        );
                      }).toList(),
                    ),
                  ),
                ],
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

  String? _deltaStr(int diff) {
    if (diff == 0) return null;
    return diff > 0 ? '↑$diff' : '↓${diff.abs()}';
  }

  String _narrativeSummary(
    int tasksDone,
    int tasksTotal,
    double income,
    double spending,
    MoodOption? avgMood,
    int habitsChecked,
    int habitsTotal,
    int totalEvents,
  ) {
    if (tasksTotal == 0 && income == 0 && spending == 0 && avgMood == null && habitsChecked == 0 && totalEvents == 0) {
      return 'No data recorded this week yet. Start by adding a task, mood, or expense!';
    }

    final parts = <String>[];

    if (tasksTotal > 0) {
      if (tasksDone == tasksTotal) {
        parts.add('All $tasksTotal tasks completed — a perfect productivity week!');
      } else if (tasksDone > tasksTotal / 2) {
        parts.add('$tasksDone of $tasksTotal tasks done — making great progress.');
      } else {
        parts.add('$tasksDone of $tasksTotal tasks completed.');
      }
    }

    if (totalEvents > 0) {
      parts.add('$totalEvents event${totalEvents == 1 ? '' : 's'} this week.');
    }

    if (avgMood != null) {
      parts.add('Mostly felt ${avgMood.label.toLowerCase()}.');
    }

    final net = income - spending;
    if (income > 0 && spending > 0) {
      parts.add('Earned +${income.toStringAsFixed(0)}, spent -${spending.toStringAsFixed(0)} (net ${net > 0 ? "+" : ""}${net.toStringAsFixed(0)}).');
    } else if (income > 0) {
      parts.add('Earned +${income.toStringAsFixed(0)}.');
    } else if (spending > 0) {
      parts.add('Spent -${spending.toStringAsFixed(0)}.');
    }

    if (habitsChecked > 0) {
      parts.add('$habitsChecked of $habitsTotal habits checked in.');
    }

    return parts.join(' ');
  }
}

class _AggregateChip extends StatelessWidget {
  const _AggregateChip({
    required this.icon,
    required this.label,
    required this.color,
    this.delta,
  });

  final IconData icon;
  final String label;
  final Color color;
  final String? delta;

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
          if (delta != null)
            Text(
              delta!,
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: color.withValues(alpha: .65)),
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
                    style:  TextStyle(fontSize: 11, color: AppColors.textMuted),
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
                    Text(_moji[mood] ?? '', style: TextStyle(fontSize: 16)),
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
                    Text(
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

class _CategoryBar extends StatelessWidget {
  const _CategoryBar({
    required this.category,
    required this.amount,
    required this.ratio,
  });

  final ExpenseCategory category;
  final double amount;
  final double ratio;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(
            category.label,
            style:  TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textMain),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Container(
            height: 18,
            decoration: BoxDecoration(
              color: AppColors.border.withValues(alpha: .3),
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: ratio,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.danger.withValues(alpha: .55),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        SizedBox(
          width: 52,
          child: Text(
            '-${amount.toStringAsFixed(0)}',
            textAlign: TextAlign.end,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.danger),
          ),
        ),
      ],
    );
  }
}

class _MoodDistributionRow extends StatelessWidget {
  const _MoodDistributionRow({required this.moodCounts});

  final Map<MoodOption, int> moodCounts;

  static const _emojis = {
    MoodOption.great: '🌟',
    MoodOption.good: '☀️',
    MoodOption.okay: '🍃',
    MoodOption.tired: '🌙',
    MoodOption.bad: '☁️',
  };

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: MoodOption.values.map((mood) {
          final count = moodCounts[mood] ?? 0;
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_emojis[mood] ?? '', style: TextStyle(fontSize: 18)),
              const SizedBox(width: 2),
              Text(
                '×$count',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: count > 0 ? AppColors.textMain : AppColors.textMuted,
                ),
              ),
            ],
          );
        }).toList(),
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
