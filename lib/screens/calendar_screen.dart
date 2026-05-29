import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../controllers/drag_event_controller.dart';
import '../models/calendar_event.dart';
import '../models/expense_entry.dart';
import '../models/habit.dart';
import '../models/habit_check_in.dart';
import '../models/mood_entry.dart';
import '../models/sync_metadata.dart';
import '../providers/calendar_view_provider.dart';
import '../providers/daily_note_provider.dart';
import '../providers/event_provider.dart';
import '../providers/expense_provider.dart';
import '../providers/habit_provider.dart';
import '../providers/mood_provider.dart';
import '../providers/sync_provider.dart';
import '../providers/todo_provider.dart';
import '../recurrence/recurrence_calculator.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import '../widgets/common/app_bottom_sheet.dart';
import '../widgets/common/soft_card.dart';
import '../widgets/common/sync_status_badge.dart';
import '../widgets/calendar/month_view.dart';
import '../widgets/home/daily_summary_card.dart';
import '../widgets/home/module_card.dart';
import '../widgets/home/upcoming_events_card.dart';
import '../widgets/home/module_sheet.dart';
import '../widgets/events/event_form.dart';
import '../widgets/expenses/expense_form.dart';
import '../widgets/habits/habit_form.dart';
import '../widgets/todos/todo_form.dart';
import '../app.dart';
import 'settings_screen.dart';

class CalendarScreen extends ConsumerWidget {
  const CalendarScreen({super.key, this.username});

  final String? username;

  static const _recurrenceCalculator = RecurrenceCalculator();
  static const _dragEventController = DragEventController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calendarView = ref.watch(calendarViewProvider);
    final calendarController = ref.read(calendarViewProvider.notifier);
    final eventList = ref.watch(eventListProvider);
    final eventController = ref.read(eventListProvider.notifier);
    final expenseList = ref.watch(expenseListProvider);
    final expenseController = ref.read(expenseListProvider.notifier);
    final todoList = ref.watch(todoListProvider);
    final todoController = ref.read(todoListProvider.notifier);
    final noteList = ref.watch(dailyNoteListProvider);
    final noteController = ref.read(dailyNoteListProvider.notifier);
    final moodList = ref.watch(moodListProvider);
    final moodController = ref.read(moodListProvider.notifier);
    final habitState = ref.watch(habitProvider);
    final habitController = ref.read(habitProvider.notifier);
    final syncState = ref.watch(syncProvider);
    final syncController = ref.read(syncProvider.notifier);
    final monthTitle = DateFormat('MMMM yyyy').format(calendarView.focusedDay);
    final selectedDateTitle = DateFormat(
      'EEEE, MMMM d',
    ).format(calendarView.selectedDay);

    PersistentBottomSheetController? eventsSheet;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Cute Daily Planner', style: TextStyle(fontSize: 16)),
            if (username != null && username!.isNotEmpty)
              Text(
                _greeting(username!),
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
              ),
          ],
        ),
        backgroundColor: AppColors.ink.withValues(alpha: .72),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            tooltip: 'Weekly overview',
            onPressed: () {
              Navigator.of(context).pushNamed(CuteCalendarApp.weeklyRoute);
            },
            icon: const Icon(Icons.view_week_rounded),
          ),
          Center(child: SyncStatusBadge(label: syncState.status.label)),
          IconButton(
            tooltip: 'Try again',
            onPressed: syncController.syncNow,
            icon: const Icon(Icons.cloud_sync_outlined),
          ),
          IconButton(
            tooltip: 'Settings',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
            icon: const Icon(Icons.settings_outlined),
          ),
          IconButton(
            tooltip: 'Logout',
            onPressed: () {
              Navigator.of(context).pushReplacementNamed(
                CuteCalendarApp.loginRoute,
              );
            },
            icon: const Icon(Icons.logout_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 1.2, sigmaY: 1.2),
                child: Image.asset(
                  'assets/images/background.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.primarySoft.withValues(alpha: .32),
                ),
              ),
            ),
            ListView(
              padding: const EdgeInsets.all(AppSpacing.md),
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(monthTitle, style: AppTextStyles.title),
                    ),
                    IconButton(
                      tooltip: 'Previous month',
                      onPressed: calendarController.goToPreviousMonth,
                      icon: const Icon(Icons.chevron_left_rounded),
                    ),
                    IconButton(
                      tooltip: 'Next month',
                      onPressed: calendarController.goToNextMonth,
                      icon: const Icon(Icons.chevron_right_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Align(
                  alignment: Alignment.centerLeft,
                  child: FilledButton.tonalIcon(
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.ink,
                    ),
                    onPressed: calendarController.goToToday,
                    icon: const Icon(Icons.today_outlined),
                    label: const Text('Today'),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Stack(
                  children: [
                    Positioned(
                      top: 0,
                      left: 18,
                      right: 18,
                      child: Container(
                        height: 6,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(999),
                          gradient: const LinearGradient(
                            colors: [
                              AppColors.primary,
                              AppColors.sage,
                              AppColors.lavender,
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: SoftCard(
                        padding: const EdgeInsets.all(AppSpacing.sm),
                        child: MonthView(
                          focusedDay: calendarView.focusedDay,
                          selectedDay: calendarView.selectedDay,
                          eventLoader: (day) =>
                              _eventsForDay(eventList.value ?? const [], day),
                          incompleteTaskLoader: (day) {
                            final tasks = (todoList.value ?? const [])
                                .where((t) => _isSameDate(t.date, day))
                                .toList();
                            return tasks.where((t) => !t.isDone).length;
                          },
                          allTasksDoneLoader: (day) {
                            final tasks = (todoList.value ?? const [])
                                .where((t) => _isSameDate(t.date, day))
                                .toList();
                            return tasks.isNotEmpty &&
                                tasks.every((t) => t.isDone);
                          },
                          hasEventsLoader: (day) =>
                              _eventsForDay(
                                  eventList.value ?? const [], day)
                                  .isNotEmpty,
                          moodLoader: (day) {
                            final entry = (moodList.value ?? const [])
                                .where(
                                    (m) => _isSameDate(m.date, day))
                                .firstOrNull;
                            return entry?.mood;
                          },
                          expenseNetLoader: (day) {
                            final entries = (expenseList.value ?? const [])
                                .where(
                                    (e) => _isSameDate(e.date, day))
                                .toList();
                            if (entries.isEmpty) return null;
                            final net = entries.fold<double>(
                              0,
                              (sum, e) => e.type == ExpenseType.income
                                  ? sum + e.amount
                                  : sum - e.amount,
                            );
                            if (net == 0) return null;
                            final sign = net > 0 ? '+' : '';
                            return '$sign${net.toStringAsFixed(0)}';
                          },
                          onDaySelected: calendarController.selectDay,
                          onEventDropped: (event, targetDay) async {
                            final movedEvent = _dragEventController
                                .moveEventToDay(event, targetDay);
                            await eventController.saveEvent(movedEvent);
                            calendarController.selectDay(targetDay, targetDay);
                            eventsSheet?.close();
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Event moved')),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(selectedDateTitle, style: AppTextStyles.sectionTitle),
                const SizedBox(height: AppSpacing.sm),
                () {
                  final selectedEvents = _eventsForDay(
                    eventList.value ?? const [],
                    calendarView.selectedDay,
                  );
                  final selectedExpenses = (expenseList.value ?? const [])
                      .where(
                        (e) => _isSameDate(e.date, calendarView.selectedDay),
                      )
                      .toList();
                  final selectedTodos = (todoList.value ?? const [])
                      .where(
                        (t) => _isSameDate(t.date, calendarView.selectedDay),
                      )
                      .toList();
                  final selectedNote =
                      (noteList.value ?? const [])
                          .where(
                            (n) => _isSameDate(
                              n.date,
                              calendarView.selectedDay,
                            ),
                          )
                          .firstOrNull;
                  final selectedMood =
                      (moodList.value ?? const [])
                          .where(
                            (m) => _isSameDate(
                              m.date,
                              calendarView.selectedDay,
                            ),
                          )
                          .firstOrNull;
                  final habits = habitState.valueOrNullForUi.habits;
                  final habitCheckIns = habitState.valueOrNullForUi.checkIns;
                  final taskDoneCount = selectedTodos.where((t) => t.isDone).length;
                  final taskTotal = selectedTodos.length;
                  final expenseNet = selectedExpenses.fold<double>(
                    0,
                    (sum, e) => e.type == ExpenseType.income
                        ? sum + e.amount
                        : sum - e.amount,
                  );
                  final habitsCheckedToday = habitCheckIns
                      .where((c) => _isSameDate(c.date, calendarView.selectedDay) && c.isDone)
                      .length;
                  final habitsTotal = habits.length;

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DailySummaryCard(
                        moodLabel: selectedMood?.mood.label,
                        expenseNet: expenseNet,
                        taskDone: taskDoneCount,
                        taskTotal: taskTotal,
                        eventCount: selectedEvents.length,
                        habitsChecked: habitsCheckedToday,
                        habitsTotal: habitsTotal,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      UpcomingEventsCard(events: _upcomingEvents(eventList.value ?? const [])),
                      const SizedBox(height: AppSpacing.md),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final cardWidth =
                              (constraints.maxWidth - AppSpacing.md) / 2;

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
                            subtitle: selectedEvents.isEmpty
                                ? 'None'
                                : _eventSubtitle(selectedEvents),
                            onTap: () {
                              final scaffold =
                                  Scaffold.of(context);
                              eventsSheet = scaffold.showBottomSheet(
                                (sheetContext) => EventsSheet(
                                  selectedDate: calendarView.selectedDay,
                                  events: selectedEvents,
                                  onAdd: () {
                                    eventsSheet?.close();
                                    _openEventForm(
                                      context: context,
                                      eventController: eventController,
                                      selectedDate: calendarView.selectedDay,
                                    );
                                  },
                                  onEventTap: (event) {
                                    eventsSheet?.close();
                                    _openEventForm(
                                      context: context,
                                      eventController: eventController,
                                      selectedDate: calendarView.selectedDay,
                                      event: event,
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          width: cardWidth,
                          child: ModuleCard(
                            icon: Icons.account_balance_wallet_rounded,
                            title: 'Expenses',
                            color: AppColors.yellow,
                            subtitle: selectedExpenses.isEmpty
                                ? 'None'
                                : _expenseSubtitle(expenseNet),
                            onTap: () => showAppBottomSheet(
                              context: context,
                              child: ExpensesSheet(
                                selectedDate: calendarView.selectedDay,
                                expenses: selectedExpenses,
                                allExpenses: expenseList.value ?? const [],
                                onAdd: () => _openExpenseForm(
                                  context: context,
                                  expenseController: expenseController,
                                  selectedDate: calendarView.selectedDay,
                                ),
                                onExpenseTap: (expense) =>
                                    _openExpenseForm(
                                  context: context,
                                  expenseController: expenseController,
                                  selectedDate: calendarView.selectedDay,
                                  expense: expense,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: cardWidth,
                          child: ModuleCard(
                            icon: Icons.checklist_rounded,
                            title: 'Tasks',
                            color: AppColors.sage,
                            subtitle: selectedTodos.isEmpty
                                ? 'None'
                                : _taskSubtitle(taskDoneCount, taskTotal),
                            onTap: () => showAppBottomSheet(
                              context: context,
                              child: TasksSheet(
                                selectedDate: calendarView.selectedDay,
                                todos: selectedTodos,
                                onAdd: () => _openTodoForm(
                                  context: context,
                                  todoController: todoController,
                                  selectedDate: calendarView.selectedDay,
                                ),
                                onToggle: todoController.toggleDone,
                                onDelete: todoController.deleteTodo,
                                onClearDone: () => todoController.clearDoneTodos(calendarView.selectedDay),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: cardWidth,
                          child: ModuleCard(
                            icon: Icons.edit_note_rounded,
                            title: 'Notes',
                            color: AppColors.lavender,
                            subtitle: selectedNote != null
                                ? _notePreview(selectedNote.content)
                                : 'Tap to write',
                            onTap: () => showAppBottomSheet(
                              context: context,
                              child: NotesSheet(
                                selectedDate: calendarView.selectedDay,
                                note: selectedNote,
                                onSave: (note) async {
                                  await noteController.saveNote(note);
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      const SnackBar(
                                        content: Text('Note saved'),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: cardWidth,
                          child: ModuleCard(
                            icon: Icons.sentiment_satisfied_alt_rounded,
                            title: 'Mood',
                            color: AppColors.pink,
                            subtitle:
                                selectedMood?.mood.label ?? 'Not set',
                            onTap: () => showAppBottomSheet(
                              context: context,
                              child: MoodSheet(
                                selectedDate: calendarView.selectedDay,
                                mood: selectedMood,
                                moodList: moodList.value ?? const [],
                                onMoodChanged: (mood) async {
                                  await moodController.saveMood(
                                    _createMoodEntry(
                                      selectedMood,
                                      calendarView.selectedDay,
                                      mood,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: cardWidth,
                          child: ModuleCard(
                            icon: Icons.auto_awesome_rounded,
                            title: 'Habits',
                            color: AppColors.mint,
                            subtitle: habits.isEmpty
                                ? 'None'
                                : _habitSubtitle(habitsCheckedToday, habitsTotal),
                            onTap: () => showAppBottomSheet(
                              context: context,
                              child: HabitsSheet(
                                selectedDate: calendarView.selectedDay,
                                habits: habits,
                                checkIns: habitCheckIns,
                                onAdd: () => _openHabitForm(
                                  context: context,
                                  habitController: habitController,
                                ),
                                onToggle: (habit, checkIn) async {
                                  await habitController.saveCheckIn(
                                    _createHabitCheckIn(
                                      habit,
                                      checkIn,
                                      calendarView.selectedDay,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                  ],
                );
              }(),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add Event',
        onPressed: () => _openEventForm(
          context: context,
          eventController: eventController,
          selectedDate: calendarView.selectedDay,
        ),
        child: const Icon(Icons.add_rounded),
      ),
      backgroundColor: AppColors.background,
    );
  }

  String _greeting(String username) {
    final hour = DateTime.now().hour;
    final timeGreeting = hour < 12 ? 'Morning' : hour < 17 ? 'Afternoon' : 'Evening';
    return 'Good $timeGreeting, $username';
  }

  bool _isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  List<CalendarEvent> _eventsForDay(List<CalendarEvent> events, DateTime day) {
    return events
        .where((event) => _recurrenceCalculator.occursOn(event, day))
        .map((event) => _recurrenceCalculator.occurrenceFor(event, day))
        .toList()
      ..sort((a, b) => a.startAt.compareTo(b.startAt));
  }

  String _eventSubtitle(List<CalendarEvent> events) {
    final timed = events.where((e) => !e.isAllDay).toList();
    if (timed.isNotEmpty) {
      final time = DateFormat('HH:mm').format(timed.first.startAt);
      return events.length == 1 ? 'at $time' : '${events.length} events, next $time';
    }
    return '${events.length} event${events.length == 1 ? '' : 's'}';
  }

  String _expenseSubtitle(double net) {
    if (net == 0) return 'Balanced';
    final sign = net > 0 ? '+' : '';
    return '$sign${net.toStringAsFixed(0)}';
  }

  String _taskSubtitle(int done, int total) {
    if (done == total) return 'All $total done!';
    return '$done / $total done';
  }

  String _notePreview(String content) {
    final trimmed = content.trim();
    if (trimmed.length <= 28) return trimmed;
    return '${trimmed.substring(0, 28)}...';
  }

  String _habitSubtitle(int checked, int total) {
    return '$checked / $total today';
  }

  List<CalendarEvent> _upcomingEvents(List<CalendarEvent> events) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final nextWeek = today.add(const Duration(days: 7));
    return events
        .where((e) {
          final occ = _recurrenceCalculator.occurrenceFor(e, today);
          final d = DateTime(occ.startAt.year, occ.startAt.month, occ.startAt.day);
          return d.isAfter(today) && d.isBefore(nextWeek.add(const Duration(days: 1)));
        })
        .map((e) => _recurrenceCalculator.occurrenceFor(e, today))
        .toList()
      ..sort((a, b) => a.startAt.compareTo(b.startAt));
  }

  Future<void> _openEventForm({
    required BuildContext context,
    required EventListController eventController,
    required DateTime selectedDate,
    CalendarEvent? event,
  }) {
    return showAppBottomSheet<void>(
      context: context,
      child: EventForm(
        selectedDate: selectedDate,
        event: event,
        onSave: (event) async {
          await eventController.saveEvent(event);
          if (context.mounted) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Event saved')));
          }
        },
        onDelete: (event) async {
          await eventController.deleteEvent(event);
          if (context.mounted) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Event deleted')));
          }
        },
      ),
    );
  }

  Future<void> _openExpenseForm({
    required BuildContext context,
    required ExpenseListController expenseController,
    required DateTime selectedDate,
    ExpenseEntry? expense,
  }) {
    return showAppBottomSheet<void>(
      context: context,
      child: ExpenseForm(
        selectedDate: selectedDate,
        expense: expense,
        onSave: (expense) async {
          await expenseController.saveExpense(expense);
          if (context.mounted) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Expense saved')));
          }
        },
        onDelete: (expense) async {
          await expenseController.deleteExpense(expense);
          if (context.mounted) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Expense deleted')));
          }
        },
      ),
    );
  }

  Future<void> _openTodoForm({
    required BuildContext context,
    required TodoListController todoController,
    required DateTime selectedDate,
  }) {
    return showAppBottomSheet<void>(
      context: context,
      child: TodoForm(
        selectedDate: selectedDate,
        onSave: (todo) async {
          await todoController.saveTodo(todo);
          if (context.mounted) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Task saved')));
          }
        },
      ),
    );
  }

  MoodEntry _createMoodEntry(
    MoodEntry? existing,
    DateTime selectedDate,
    MoodOption mood,
  ) {
    final now = DateTime.now();
    return MoodEntry(
      id:
          existing?.id ??
          '${selectedDate.year}-${selectedDate.month}-${selectedDate.day}',
      userId: existing?.userId ?? 'local-user',
      date: DateTime(selectedDate.year, selectedDate.month, selectedDate.day),
      mood: mood,
      note: existing?.note ?? '',
      createdAt: existing?.createdAt ?? now,
      updatedAt: now,
      syncStatus: SyncStatus.localOnly,
      version: (existing?.version ?? 0) + 1,
    );
  }

  Future<void> _openHabitForm({
    required BuildContext context,
    required HabitController habitController,
  }) {
    return showAppBottomSheet<void>(
      context: context,
      child: HabitForm(
        onSave: (habit) async {
          await habitController.saveHabit(habit);
          if (context.mounted) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Habit saved')));
          }
        },
      ),
    );
  }

  HabitCheckIn _createHabitCheckIn(
    Habit habit,
    HabitCheckIn? existing,
    DateTime selectedDate,
  ) {
    final now = DateTime.now();
    final dateOnly = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
    );
    return HabitCheckIn(
      id: existing?.id ?? '${habit.id}-${dateOnly.toIso8601String()}',
      habitId: habit.id,
      userId: habit.userId,
      date: dateOnly,
      isDone: !(existing?.isDone ?? false),
      createdAt: existing?.createdAt ?? now,
      updatedAt: now,
      syncStatus: SyncStatus.localOnly,
      version: (existing?.version ?? 0) + 1,
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
