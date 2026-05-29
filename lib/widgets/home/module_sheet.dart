import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/calendar_event.dart';
import '../../models/daily_note.dart';
import '../../models/expense_entry.dart';
import '../../models/habit.dart';
import '../../models/habit_check_in.dart';
import '../../models/mood_entry.dart';
import '../../models/todo_item.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';
import '../calendar/draggable_event_tile.dart';
import '../common/empty_state.dart';
import '../common/soft_card.dart';
import '../expenses/expense_card.dart';
import '../expenses/expense_summary_bar.dart';
import '../expenses/expense_summary_card.dart';
import '../habits/habit_check_list.dart';
import '../mood/mood_picker.dart';
import '../mood/mood_trend_row.dart';
import '../notes/daily_note_editor.dart';
import '../todos/todo_list.dart';

class _SheetHeader extends StatelessWidget {
  const _SheetHeader({required this.title, required this.date});

  final String title;
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final formatted = DateFormat('EEE, MMM d').format(date);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.sm,
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 24,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.sectionTitle),
                Text(formatted, style: AppTextStyles.muted),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close_rounded),
          ),
        ],
      ),
    );
  }
}

class EventsSheet extends StatelessWidget {
  const EventsSheet({
    required this.selectedDate,
    required this.events,
    required this.onAdd,
    required this.onEventTap,
    super.key,
  });

  final DateTime selectedDate;
  final List<CalendarEvent> events;
  final VoidCallback onAdd;
  final ValueChanged<CalendarEvent> onEventTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SheetHeader(title: 'Events', date: selectedDate),
        const Divider(),
        Flexible(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: events.isEmpty
                ? const EmptyState(
                    icon: Icons.event_available_outlined,
                    title: 'No events',
                    message: 'Add a little plan for this day',
                  )
                : Column(
                    children: events
                        .map(
                          (event) => DraggableEventTile(
                            event: event,
                            onTap: () {
                              Navigator.of(context).pop();
                              onEventTap(event);
                            },
                          ),
                        )
                        .toList(),
                  ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: FilledButton.icon(
            onPressed: () {
              Navigator.of(context).pop();
              onAdd();
            },
            icon: const Icon(Icons.add_rounded),
            label: const Text('Add Event'),
          ),
        ),
      ],
    );
  }
}

class ExpensesSheet extends StatelessWidget {
  const ExpensesSheet({
    required this.selectedDate,
    required this.expenses,
    required this.allExpenses,
    required this.onAdd,
    required this.onExpenseTap,
    super.key,
  });

  final DateTime selectedDate;
  final List<ExpenseEntry> expenses;
  final List<ExpenseEntry> allExpenses;
  final VoidCallback onAdd;
  final ValueChanged<ExpenseEntry> onExpenseTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SheetHeader(title: 'Expenses', date: selectedDate),
        const Divider(),
        Flexible(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              children: [
                ExpenseSummaryCard(expenses: expenses),
                const SizedBox(height: AppSpacing.sm),
                ExpenseSummaryBar(expenses: allExpenses, selectedDate: selectedDate),
                if (expenses.isNotEmpty) const SizedBox(height: AppSpacing.sm),
                if (expenses.isEmpty)
                  const EmptyState(
                    icon: Icons.account_balance_wallet_outlined,
                    title: 'No expenses',
                    message: 'Add an expense for this day',
                  )
                else
                  ...expenses.map(
                    (expense) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: ExpenseCard(
                        expense: expense,
                        onTap: () {
                          Navigator.of(context).pop();
                          onExpenseTap(expense);
                        },
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: FilledButton.icon(
            onPressed: () {
              Navigator.of(context).pop();
              onAdd();
            },
            icon: const Icon(Icons.add_rounded),
            label: const Text('Add Expense'),
          ),
        ),
      ],
    );
  }
}

class TasksSheet extends StatelessWidget {
  const TasksSheet({
    required this.selectedDate,
    required this.todos,
    required this.onAdd,
    required this.onToggle,
    required this.onDelete,
    super.key,
  });

  final DateTime selectedDate;
  final List<TodoItem> todos;
  final VoidCallback onAdd;
  final ValueChanged<TodoItem> onToggle;
  final ValueChanged<TodoItem> onDelete;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SheetHeader(title: 'Tasks', date: selectedDate),
        const Divider(),
        Flexible(
          child: TodoList(
            todos: todos,
            onToggle: onToggle,
            onDelete: onDelete,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: FilledButton.icon(
            onPressed: () {
              Navigator.of(context).pop();
              onAdd();
            },
            icon: const Icon(Icons.add_rounded),
            label: const Text('Add Task'),
          ),
        ),
      ],
    );
  }
}

class NotesSheet extends StatelessWidget {
  const NotesSheet({
    required this.selectedDate,
    required this.note,
    required this.onSave,
    super.key,
  });

  final DateTime selectedDate;
  final DailyNote? note;
  final ValueChanged<DailyNote> onSave;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SheetHeader(title: 'Notes', date: selectedDate),
        const Divider(),
        Flexible(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: DailyNoteEditor(
              selectedDate: selectedDate,
              note: note,
              onSave: onSave,
            ),
          ),
        ),
      ],
    );
  }
}

class MoodSheet extends StatelessWidget {
  const MoodSheet({
    required this.selectedDate,
    required this.mood,
    required this.moodList,
    required this.onMoodChanged,
    super.key,
  });

  final DateTime selectedDate;
  final MoodEntry? mood;
  final List<MoodEntry> moodList;
  final ValueChanged<MoodOption> onMoodChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SheetHeader(title: 'Mood', date: selectedDate),
        const Divider(),
        Flexible(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('How are you feeling today?', style: AppTextStyles.body),
                const SizedBox(height: AppSpacing.md),
                MoodPicker(
                  selectedMood: mood?.mood,
                  onChanged: onMoodChanged,
                ),
                if (mood != null) ...[
                  const SizedBox(height: AppSpacing.md),
                  SoftCard(
                    child: Text(
                      'Today feels ${mood!.mood.label}',
                      style: AppTextStyles.body,
                    ),
                  ),
                ],
                MoodTrendRow(moods: moodList, selectedDate: selectedDate),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class HabitsSheet extends StatelessWidget {
  const HabitsSheet({
    required this.selectedDate,
    required this.habits,
    required this.checkIns,
    required this.onAdd,
    required this.onToggle,
    super.key,
  });

  final DateTime selectedDate;
  final List<Habit> habits;
  final List<HabitCheckIn> checkIns;
  final VoidCallback onAdd;
  final void Function(Habit habit, HabitCheckIn? checkIn) onToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SheetHeader(title: 'Habits', date: selectedDate),
        const Divider(),
        Flexible(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: HabitCheckList(
              habits: habits,
              checkIns: checkIns,
              selectedDate: selectedDate,
              onToggle: onToggle,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: FilledButton.icon(
            onPressed: () {
              Navigator.of(context).pop();
              onAdd();
            },
            icon: const Icon(Icons.add_rounded),
            label: const Text('Add Habit'),
          ),
        ),
      ],
    );
  }
}
