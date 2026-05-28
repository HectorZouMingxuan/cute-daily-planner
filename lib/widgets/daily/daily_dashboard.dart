import 'package:flutter/material.dart';

import '../../models/calendar_event.dart';
import '../../models/daily_note.dart';
import '../../models/expense_entry.dart';
import '../../models/habit.dart';
import '../../models/habit_check_in.dart';
import '../../models/mood_entry.dart';
import '../../models/todo_item.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../calendar/draggable_event_tile.dart';
import '../common/empty_state.dart';
import '../common/soft_card.dart';
import '../expenses/expense_card.dart';
import '../expenses/expense_summary_card.dart';
import '../habits/habit_check_list.dart';
import '../mood/mood_picker.dart';
import '../notes/daily_note_editor.dart';
import '../todos/todo_list.dart';
import 'daily_section_header.dart';
import 'daily_tab_bar.dart';

class DailyDashboard extends StatelessWidget {
  const DailyDashboard({
    required this.selectedDate,
    required this.events,
    required this.expenses,
    required this.todos,
    required this.dailyNote,
    required this.mood,
    required this.habits,
    required this.habitCheckIns,
    required this.onEventTap,
    required this.onAddExpense,
    required this.onExpenseTap,
    required this.onAddTask,
    required this.onToggleTask,
    required this.onDeleteTask,
    required this.onSaveNote,
    required this.onMoodChanged,
    required this.onAddHabit,
    required this.onToggleHabit,
    super.key,
  });

  final DateTime selectedDate;
  final List<CalendarEvent> events;
  final List<ExpenseEntry> expenses;
  final List<TodoItem> todos;
  final DailyNote? dailyNote;
  final MoodEntry? mood;
  final List<Habit> habits;
  final List<HabitCheckIn> habitCheckIns;
  final ValueChanged<CalendarEvent> onEventTap;
  final VoidCallback onAddExpense;
  final ValueChanged<ExpenseEntry> onExpenseTap;
  final VoidCallback onAddTask;
  final ValueChanged<TodoItem> onToggleTask;
  final ValueChanged<TodoItem> onDeleteTask;
  final ValueChanged<DailyNote> onSaveNote;
  final ValueChanged<MoodOption> onMoodChanged;
  final VoidCallback onAddHabit;
  final void Function(Habit habit, HabitCheckIn? checkIn) onToggleHabit;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DailyTabBar(),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            height: 500,
            child: TabBarView(
              children: [
                _DashboardPane(
                  color: AppColors.sage.withValues(alpha: .18),
                  child: _PlanTab(
                    events: events,
                    mood: mood,
                    selectedDate: selectedDate,
                    habits: habits,
                    habitCheckIns: habitCheckIns,
                    onEventTap: onEventTap,
                    onMoodChanged: onMoodChanged,
                    onAddHabit: onAddHabit,
                    onToggleHabit: onToggleHabit,
                  ),
                ),
                _DashboardPane(
                  color: AppColors.yellow.withValues(alpha: .15),
                  child: _MoneyTab(
                    expenses: expenses,
                    onAddExpense: onAddExpense,
                    onExpenseTap: onExpenseTap,
                  ),
                ),
                _DashboardPane(
                  color: AppColors.lavender.withValues(alpha: .16),
                  child: _TasksTab(
                    todos: todos,
                    onAddTask: onAddTask,
                    onToggleTask: onToggleTask,
                    onDeleteTask: onDeleteTask,
                  ),
                ),
                _DashboardPane(
                  color: AppColors.pink.withValues(alpha: .13),
                  child: DailyNoteEditor(
                    selectedDate: selectedDate,
                    note: dailyNote,
                    onSave: onSaveNote,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DashboardPane extends StatelessWidget {
  const _DashboardPane({required this.color, required this.child});

  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppRadius.large),
        border: Border.all(color: Colors.white.withValues(alpha: .24)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            Row(
              children: [
                _MiniBlock(color: AppColors.primary, width: 44),
                const SizedBox(width: AppSpacing.sm),
                _MiniBlock(color: AppColors.sage, width: 24),
                const Spacer(),
                _MiniBlock(color: AppColors.lavender, width: 58),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}

class _MiniBlock extends StatelessWidget {
  const _MiniBlock({required this.color, required this.width});

  final Color color;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 6,
      decoration: BoxDecoration(
        color: color.withValues(alpha: .75),
        borderRadius: BorderRadius.circular(999),
      ),
    );
  }
}

class _TasksTab extends StatelessWidget {
  const _TasksTab({
    required this.todos,
    required this.onAddTask,
    required this.onToggleTask,
    required this.onDeleteTask,
  });

  final List<TodoItem> todos;
  final VoidCallback onAddTask;
  final ValueChanged<TodoItem> onToggleTask;
  final ValueChanged<TodoItem> onDeleteTask;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DailySectionHeader(
          title: 'Today Tasks',
          action: FilledButton.icon(
            onPressed: onAddTask,
            icon: const Icon(Icons.add_rounded),
            label: const Text('Add Task'),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Expanded(
          child: TodoList(
            todos: todos,
            onToggle: onToggleTask,
            onDelete: onDeleteTask,
          ),
        ),
      ],
    );
  }
}

class _MoneyTab extends StatelessWidget {
  const _MoneyTab({
    required this.expenses,
    required this.onAddExpense,
    required this.onExpenseTap,
  });

  final List<ExpenseEntry> expenses;
  final VoidCallback onAddExpense;
  final ValueChanged<ExpenseEntry> onExpenseTap;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        ExpenseSummaryCard(expenses: expenses),
        const SizedBox(height: AppSpacing.md),
        DailySectionHeader(
          title: 'Money',
          action: FilledButton.icon(
            onPressed: onAddExpense,
            icon: const Icon(Icons.add_rounded),
            label: const Text('Add Expense'),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        if (expenses.isEmpty)
          const SoftCard(
            child: EmptyState(
              icon: Icons.account_balance_wallet_outlined,
              title: 'No expenses today',
              message: 'Add Expense',
            ),
          )
        else
          ...expenses.map(
            (expense) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: ExpenseCard(
                expense: expense,
                onTap: () => onExpenseTap(expense),
              ),
            ),
          ),
      ],
    );
  }
}

class _PlanTab extends StatelessWidget {
  const _PlanTab({
    required this.events,
    required this.mood,
    required this.selectedDate,
    required this.habits,
    required this.habitCheckIns,
    required this.onEventTap,
    required this.onMoodChanged,
    required this.onAddHabit,
    required this.onToggleHabit,
  });

  final List<CalendarEvent> events;
  final MoodEntry? mood;
  final DateTime selectedDate;
  final List<Habit> habits;
  final List<HabitCheckIn> habitCheckIns;
  final ValueChanged<CalendarEvent> onEventTap;
  final ValueChanged<MoodOption> onMoodChanged;
  final VoidCallback onAddHabit;
  final void Function(Habit habit, HabitCheckIn? checkIn) onToggleHabit;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth > 720;
            final eventPanel = _DecoratedPanel(
              accentColor: AppColors.primary,
              title: 'Events',
              child: events.isEmpty
                  ? const EmptyState(
                      icon: Icons.event_available_outlined,
                      title: 'No events today',
                      message: 'Add a little plan',
                    )
                  : Column(
                      children: events
                          .map(
                            (event) => DraggableEventTile(
                              event: event,
                              onTap: () => onEventTap(event),
                            ),
                          )
                          .toList(),
                    ),
            );
            final habitPanel = _DecoratedPanel(
              accentColor: AppColors.sage,
              title: 'Habits',
              action: FilledButton.icon(
                onPressed: onAddHabit,
                icon: const Icon(Icons.add_rounded),
                label: const Text('Add Habit'),
              ),
              child: HabitCheckList(
                habits: habits,
                checkIns: habitCheckIns,
                selectedDate: selectedDate,
                onToggle: onToggleHabit,
              ),
            );
            final moodPanel = _DecoratedPanel(
              accentColor: AppColors.lavender,
              title: 'Mood',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MoodPicker(
                    selectedMood: mood?.mood,
                    onChanged: onMoodChanged,
                  ),
                  if (mood != null) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Text('Today feels ${mood!.mood.label}'),
                  ],
                ],
              ),
            );

            if (!wide) {
              return Column(
                children: [
                  eventPanel,
                  const SizedBox(height: AppSpacing.md),
                  habitPanel,
                  const SizedBox(height: AppSpacing.md),
                  moodPanel,
                ],
              );
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 3, child: eventPanel),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      habitPanel,
                      const SizedBox(height: AppSpacing.md),
                      moodPanel,
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _DecoratedPanel extends StatelessWidget {
  const _DecoratedPanel({
    required this.accentColor,
    required this.title,
    required this.child,
    this.action,
  });

  final Color accentColor;
  final String title;
  final Widget child;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 12,
          right: 18,
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: .16),
              borderRadius: BorderRadius.circular(18),
            ),
          ),
        ),
        SoftCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DailySectionHeader(title: title, action: action),
              const SizedBox(height: AppSpacing.md),
              child,
            ],
          ),
        ),
      ],
    );
  }
}
