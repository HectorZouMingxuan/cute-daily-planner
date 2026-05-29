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
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';
import '../calendar/draggable_event_tile.dart';
import '../common/empty_state.dart';
import '../common/section_header.dart';
import '../common/soft_card.dart';
import '../expenses/expense_card.dart';
import '../expenses/expense_summary_bar.dart';
import '../expenses/expense_summary_card.dart';
import '../habits/habit_check_list.dart';
import '../mood/mood_picker.dart';
import '../mood/mood_trend_row.dart';
import '../notes/daily_note_editor.dart';
import '../todos/todo_list.dart';

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
        SectionHeader(title: 'Events', subtitle: DateFormat('EEE, MMM d').format(selectedDate), trailing: IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.close_rounded))),
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
        SectionHeader(title: 'Expenses', subtitle: DateFormat('EEE, MMM d').format(selectedDate), trailing: IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.close_rounded))),
        const Divider(),
        Flexible(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              children: [
                ExpenseSummaryCard(expenses: expenses),
                const SizedBox(height: AppSpacing.sm),
                ExpenseSummaryBar(expenses: allExpenses, selectedDate: selectedDate),
                const SizedBox(height: AppSpacing.sm),
                _MonthlyTotal(allExpenses: allExpenses, selectedDate: selectedDate),
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
    required this.onAdd,
    required this.onToggle,
    required this.onDelete,
    this.onClearDone,
    super.key,
  });

  final DateTime selectedDate;
  final VoidCallback onAdd;
  final ValueChanged<TodoItem> onToggle;
  final ValueChanged<TodoItem> onDelete;
  final VoidCallback? onClearDone;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(title: 'Tasks', subtitle: DateFormat('EEE, MMM d').format(selectedDate), trailing: IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.close_rounded))),
        const Divider(),
        Flexible(
          child: TodoList(
            selectedDate: selectedDate,
            onToggle: onToggle,
            onDelete: onDelete,
            onClearDone: onClearDone,
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
        SectionHeader(title: 'Notes', subtitle: DateFormat('EEE, MMM d').format(selectedDate), trailing: IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.close_rounded))),
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

class MoodSheet extends StatefulWidget {
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
  final void Function(MoodOption mood, String note) onMoodChanged;

  @override
  State<MoodSheet> createState() => _MoodSheetState();
}

class _MoodSheetState extends State<MoodSheet> {
  late final TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController(text: widget.mood?.note ?? '');
  }

  @override
  void didUpdateWidget(covariant MoodSheet oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.mood?.note != widget.mood?.note) {
      _noteController.text = widget.mood?.note ?? '';
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(title: 'Mood', subtitle: DateFormat('EEE, MMM d').format(widget.selectedDate), trailing: IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.close_rounded))),
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
                  selectedMood: widget.mood?.mood,
                  onChanged: (mood) => widget.onMoodChanged(mood, _noteController.text.trim()),
                ),
                const SizedBox(height: AppSpacing.md),
                TextField(
                  controller: _noteController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    hintText: 'Add a note... (optional)',
                    hintStyle: TextStyle(color: AppColors.textMuted, fontSize: 13),
                    contentPadding: const EdgeInsets.all(AppSpacing.sm + 2),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.small),
                      borderSide: BorderSide(color: AppColors.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.small),
                      borderSide: BorderSide(color: AppColors.border.withValues(alpha: .5)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.small),
                      borderSide: BorderSide(color: AppColors.primary),
                    ),
                  ),
                  style: TextStyle(fontSize: 13, color: AppColors.textMain),
                ),
                if (widget.mood != null) ...[
                  const SizedBox(height: AppSpacing.md),
                  if (widget.mood!.note.isNotEmpty)
                    SoftCard(
                      child: Text(
                        widget.mood!.note,
                        style: AppTextStyles.body,
                      ),
                    )
                  else
                    SoftCard(
                      child: Text(
                        'Today feels ${widget.mood!.mood.label}',
                        style: AppTextStyles.body,
                      ),
                    ),
                ],
                MoodTrendRow(moods: widget.moodList, selectedDate: widget.selectedDate),
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
    required this.onDelete,
    super.key,
  });

  final DateTime selectedDate;
  final List<Habit> habits;
  final List<HabitCheckIn> checkIns;
  final VoidCallback onAdd;
  final void Function(Habit habit, HabitCheckIn? checkIn) onToggle;
  final ValueChanged<Habit> onDelete;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(title: 'Habits', subtitle: DateFormat('EEE, MMM d').format(selectedDate), trailing: IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.close_rounded))),
        const Divider(),
        Flexible(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: HabitCheckList(
              habits: habits,
              checkIns: checkIns,
              selectedDate: selectedDate,
              onToggle: onToggle,
              onDelete: onDelete,
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

class _MonthlyTotal extends StatelessWidget {
  const _MonthlyTotal({required this.allExpenses, required this.selectedDate});

  final List<ExpenseEntry> allExpenses;
  final DateTime selectedDate;

  @override
  Widget build(BuildContext context) {
    final month = selectedDate.month;
    final year = selectedDate.year;
    final monthExpenses = allExpenses.where((e) => e.date.month == month && e.date.year == year).toList();

    if (monthExpenses.isEmpty) return const SizedBox.shrink();

    var income = 0.0;
    var spending = 0.0;
    for (final e in monthExpenses) {
      if (e.type == ExpenseType.income) {
        income += e.amount;
      } else {
        spending += e.amount;
      }
    }
    final net = income - spending;

    return SoftCard(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      child: Row(
        children: [
          Text(
            DateFormat('MMM yyyy').format(selectedDate),
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.textMain),
          ),
          const SizedBox(width: AppSpacing.sm),
          if (income > 0)
            Text(
              '+${income.toStringAsFixed(0)}',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.mint),
            ),
          if (income > 0 && spending > 0)
            Text('  ', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
          if (spending > 0)
            Text(
              '-${spending.toStringAsFixed(0)}',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.danger),
            ),
          if ((income > 0 || spending > 0) && net != 0) ...[
            const SizedBox(width: AppSpacing.sm),
            Text(
              'net ${net > 0 ? "+" : ""}${net.toStringAsFixed(0)}',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: net > 0 ? AppColors.mint : AppColors.danger,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
