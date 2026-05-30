import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../controllers/drag_event_controller.dart';
import '../models/calendar_event.dart';
import '../models/daily_note.dart';
import '../models/expense_entry.dart';
import '../models/habit.dart';
import '../models/habit_check_in.dart';
import '../models/mood_entry.dart';
import '../models/sync_metadata.dart';
import '../models/todo_item.dart';
import '../providers/calendar_view_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/user_provider.dart';
import '../providers/daily_note_provider.dart';
import '../providers/event_provider.dart';
import '../providers/expense_provider.dart';
import '../providers/habit_provider.dart';
import '../providers/mood_provider.dart';
import '../providers/sync_provider.dart';
import '../providers/todo_provider.dart';
import '../recurrence/recurrence_calculator.dart';
import '../theme/app_colors.dart';
import '../theme/app_date_utils.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import '../widgets/common/app_bottom_sheet.dart';
import '../widgets/common/app_notification.dart';
import '../widgets/common/planner_card.dart';
import '../widgets/common/sync_status_badge.dart';
import '../widgets/calendar/month_view.dart';
import '../widgets/home/daily_summary_card.dart';
import '../widgets/home/upcoming_events_card.dart';
import '../widgets/home/calendar_background.dart';
import '../widgets/home/calendar_header.dart';
import '../widgets/home/module_card.dart';
import '../widgets/home/module_sheet.dart';
import '../widgets/calendar/month_picker_dialog.dart';
import '../widgets/events/event_form.dart';
import '../widgets/expenses/expense_form.dart';
import '../widgets/habits/habit_form.dart';
import '../widgets/todos/todo_form.dart';
import 'settings_screen.dart';

class CalendarScreen extends ConsumerWidget {
  const CalendarScreen({super.key});

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
    final now = DateTime.now();
    final isToday = now.year == calendarView.selectedDay.year &&
        now.month == calendarView.selectedDay.month &&
        now.day == calendarView.selectedDay.day;
    final selectedDateTitle = isToday
        ? 'Today, ${DateFormat('MMM d').format(calendarView.selectedDay)}'
        : DateFormat('EEEE, MMMM d').format(calendarView.selectedDay);

    final monthlySummary = _monthlySummary(
      calendarView.focusedDay,
      eventList.value ?? const [],
      todoList.value ?? const [],
      expenseList.value ?? const [],
      habitState.valueOrNullForUi.checkIns,
      noteList.value ?? const [],
    );

    PersistentBottomSheetController? eventsSheet;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Cute Daily Planner',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
            () {
              final authUser = ref.watch(authStateProvider).asData?.value;
              if (authUser != null) {
                return Text(
                  _greeting(authUser.displayName),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withValues(alpha: .8),
                  ),
                );
              }
              return const SizedBox.shrink();
            }(),
          ],
        ),
        backgroundColor: AppColors.appBarBg,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            tooltip: 'Weekly overview',
            onPressed: () => Navigator.of(context).pushNamed('/weekly'),
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
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const SettingsScreen(),
              ),
            ),
            icon: const Icon(Icons.settings_outlined),
          ),
          IconButton(
            tooltip: 'Logout',
            onPressed: () => _confirmLogout(context, ref),
            icon: const Icon(Icons.logout_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            const CalendarBackground(),
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 640),
                child: ListView(
                  padding: const EdgeInsets.all(AppSpacing.screenH),
                  children: [
                    CalendarHeader(
                      monthTitle: monthTitle,
                      monthlySummary: monthlySummary,
                      calendarController: calendarController,
                      onMonthTap: () => showMonthPickerDialog(
                        context,
                        calendarView.focusedDay,
                        calendarController,
                      ),
                    ),
                    // Calendar grid card
                    PlannerCard(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.sm,
                      ),
                      child: GestureDetector(
                        onHorizontalDragEnd: (details) {
                          if (details.primaryVelocity == null) return;
                          if (details.primaryVelocity! < -100) {
                            calendarController.goToNextMonth();
                          } else if (details.primaryVelocity! > 100) {
                            calendarController.goToPreviousMonth();
                          }
                        },
                        child: MonthView(
                          focusedDay: calendarView.focusedDay,
                          selectedDay: calendarView.selectedDay,
                          eventLoader: (day) =>
                              _eventsForDay(eventList.value ?? const [], day),
                          incompleteTaskLoader: (day) {
                            final tasks = (todoList.value ?? const [])
                                .where((t) => AppDateUtils.isSameDate(t.date, day))
                                .toList();
                            return tasks.where((t) => !t.isDone).length;
                          },
                          allTasksDoneLoader: (day) {
                            final tasks = (todoList.value ?? const [])
                                .where((t) => AppDateUtils.isSameDate(t.date, day))
                                .toList();
                            return tasks.isNotEmpty &&
                                tasks.every((t) => t.isDone);
                          },
                          hasEventsLoader: (day) =>
                              _eventsForDay(eventList.value ?? const [], day)
                                  .isNotEmpty,
                          moodLoader: (day) {
                            final entry = (moodList.value ?? const [])
                                .where((m) => AppDateUtils.isSameDate(m.date, day))
                                .firstOrNull;
                            return entry?.mood;
                          },
                          expenseNetLoader: (day) {
                            final entries = (expenseList.value ?? const [])
                                .where((e) => AppDateUtils.isSameDate(e.date, day))
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
                            final movedEvent =
                                _dragEventController.moveEventToDay(event, targetDay);
                            await eventController.saveEvent(movedEvent);
                            calendarController.selectDay(targetDay, targetDay);
                            eventsSheet?.close();
                            if (context.mounted) {
                              AppNotification.info(context, 'Event moved');
                            }
                          },
                          onDayLongPress: (day) {
                            calendarController.selectDay(day, day);
                            _showQuickActions(
                              context,
                              ref,
                              day,
                              eventController,
                              todoController,
                              expenseController,
                              noteController,
                              noteList,
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.section),
                    // Selected date title
                    Text(selectedDateTitle, style: AppTextStyles.heading),
                    const SizedBox(height: AppSpacing.sm),
                    // Daily summary
                    () {
                      final selectedEvents = _eventsForDay(
                        eventList.value ?? const [],
                        calendarView.selectedDay,
                      )..sort((a, b) => a.startAt.compareTo(b.startAt));
                      final selectedExpenses = (expenseList.value ?? const [])
                          .where((e) => AppDateUtils.isSameDate(
                              e.date, calendarView.selectedDay))
                          .toList();
                      final selectedTodos = (todoList.value ?? const [])
                          .where((t) => AppDateUtils.isSameDate(
                              t.date, calendarView.selectedDay))
                          .toList();
                      final selectedNote = (noteList.value ?? const [])
                          .where((n) => AppDateUtils.isSameDate(
                              n.date, calendarView.selectedDay))
                          .firstOrNull;
                      final selectedMood = (moodList.value ?? const [])
                          .where((m) => AppDateUtils.isSameDate(
                              m.date, calendarView.selectedDay))
                          .firstOrNull;
                      final habits = habitState.valueOrNullForUi.habits;
                      final habitCheckIns = habitState.valueOrNullForUi.checkIns;
                      final taskDoneCount =
                          selectedTodos.where((t) => t.isDone).length;
                      final taskTotal = selectedTodos.length;
                      final expenseNet = selectedExpenses.fold<double>(
                        0,
                        (sum, e) => e.type == ExpenseType.income
                            ? sum + e.amount
                            : sum - e.amount,
                      );
                      final habitsCheckedToday = habitCheckIns
                          .where((c) =>
                              AppDateUtils.isSameDate(
                                  c.date, calendarView.selectedDay) &&
                              c.isDone)
                          .length;
                      final habitsTotal = habits.length;

                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          DailySummaryCard(
                            mood: selectedMood?.mood,
                            expenseNet: expenseNet,
                            taskDone: taskDoneCount,
                            taskTotal: taskTotal,
                            eventCount: selectedEvents.length,
                            habitsChecked: habitsCheckedToday,
                            habitsTotal: habitsTotal,
                          ),
                          const SizedBox(height: AppSpacing.cardGap),
                          UpcomingEventsCard(
                            events:
                                _upcomingEvents(eventList.value ?? const []),
                          ),
                          const SizedBox(height: AppSpacing.cardGap),
                          // Module grid — 2 columns
                          LayoutBuilder(
                            builder: (context, constraints) {
                              final cardWidth =
                                  (constraints.maxWidth - AppSpacing.cardGap) /
                                      2;

                              return Wrap(
                                spacing: AppSpacing.cardGap,
                                runSpacing: AppSpacing.cardGap,
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
                                        final scaffold = Scaffold.of(context);
                                        eventsSheet =
                                            scaffold.showBottomSheet(
                                          (sheetContext) => EventsSheet(
                                            selectedDate:
                                                calendarView.selectedDay,
                                            events: selectedEvents,
                                            onAdd: () {
                                              eventsSheet?.close();
                                              _openEventForm(
                                                context: context,
                                                eventController:
                                                    eventController,
                                                selectedDate:
                                                    calendarView.selectedDay,
                                              );
                                            },
                                            onEventTap: (event) {
                                              eventsSheet?.close();
                                              _openEventForm(
                                                context: context,
                                                eventController:
                                                    eventController,
                                                selectedDate:
                                                    calendarView.selectedDay,
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
                                      icon:
                                          Icons.account_balance_wallet_rounded,
                                      title: 'Expenses',
                                      color: AppColors.yellow,
                                      subtitle: selectedExpenses.isEmpty
                                          ? 'None'
                                          : _expenseSubtitle(expenseNet,
                                              selectedExpenses.length),
                                      onTap: () => showAppBottomSheet(
                                        context: context,
                                        child: ExpensesSheet(
                                          selectedDate:
                                              calendarView.selectedDay,
                                          expenses: selectedExpenses,
                                          allExpenses:
                                              expenseList.value ?? const [],
                                          onAdd: () => _openExpenseForm(
                                            context: context,
                                            expenseController:
                                                expenseController,
                                            selectedDate:
                                                calendarView.selectedDay,
                                          ),
                                          onExpenseTap: (expense) =>
                                              _openExpenseForm(
                                            context: context,
                                            expenseController:
                                                expenseController,
                                            selectedDate:
                                                calendarView.selectedDay,
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
                                          : _taskSubtitle(
                                              taskDoneCount, taskTotal),
                                      onTap: () => showAppBottomSheet(
                                        context: context,
                                        child: TasksSheet(
                                          selectedDate:
                                              calendarView.selectedDay,
                                          onAdd: () => _openTodoForm(
                                            context: context,
                                            todoController: todoController,
                                            selectedDate:
                                                calendarView.selectedDay,
                                          ),
                                          onToggle: (todo) async {
                                            await todoController
                                                .toggleDone(todo);
                                            if (!context.mounted) return;
                                            final newIsDone = !todo.isDone;
                                            AppNotification.success(
                                              context,
                                              newIsDone
                                                  ? 'Task completed'
                                                  : 'Task marked as incomplete',
                                            );
                                            final currentTodos =
                                                ref
                                                    .read(todoListProvider)
                                                    .value ?? [];
                                            final dayTodos = currentTodos
                                                .where((t) =>
                                                    AppDateUtils.isSameDate(
                                                        t.date,
                                                        calendarView
                                                            .selectedDay))
                                                .toList();
                                            if (dayTodos.isNotEmpty &&
                                                dayTodos.every(
                                                    (t) => t.isDone)) {
                                              AppNotification.success(
                                                context,
                                                'All tasks completed for the day!',
                                              );
                                            }
                                          },
                                          onDelete: (todo) {
                                            todoController.deleteTodo(todo);
                                            AppNotification.confirm(
                                              context,
                                              'Task deleted',
                                              actionLabel: 'Undo',
                                              onAction: () =>
                                                  todoController
                                                      .restoreTodo(todo),
                                            );
                                          },
                                          onClearDone: () =>
                                              todoController.clearDoneTodos(
                                                  calendarView.selectedDay),
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
                                          selectedDate:
                                              calendarView.selectedDay,
                                          note: selectedNote,
                                          onSave: (note) async {
                                            await noteController.saveNote(note);
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: cardWidth,
                                    child: ModuleCard(
                                      icon:
                                          Icons.sentiment_satisfied_alt_rounded,
                                      title: 'Mood',
                                      color: AppColors.pink,
                                      subtitle: selectedMood?.mood.label ??
                                          'Not set',
                                      onTap: () => showAppBottomSheet(
                                        context: context,
                                        child: MoodSheet(
                                          selectedDate:
                                              calendarView.selectedDay,
                                          mood: selectedMood,
                                          moodList:
                                              moodList.value ?? const [],
                                          onMoodChanged: (mood, note) async {
                                            await moodController.saveMood(
                                              _createMoodEntry(
                                                selectedMood,
                                                calendarView.selectedDay,
                                                mood,
                                                userId: ref.read(
                                                    currentUserIdProvider),
                                                note: note,
                                              ),
                                            );
                                            if (context.mounted) {
                                              AppNotification.success(
                                                context,
                                                'Mood saved',
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
                                      icon: Icons.auto_awesome_rounded,
                                      title: 'Habits',
                                      color: AppColors.mint,
                                      subtitle: habits.isEmpty
                                          ? 'None'
                                          : _habitSubtitle(
                                              habitsCheckedToday, habitsTotal),
                                      onTap: () => showAppBottomSheet(
                                        context: context,
                                        child: HabitsSheet(
                                          selectedDate:
                                              calendarView.selectedDay,
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
                                          onDelete: (habit) =>
                                              habitController
                                                  .deleteHabit(habit.id),
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
              ),
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

  // ── Quick-actions bottom sheet ──────────────────────────────────

  void _showQuickActions(
    BuildContext context,
    WidgetRef ref,
    DateTime day,
    EventListController eventController,
    TodoListController todoController,
    ExpenseListController expenseController,
    DailyNoteListController noteController,
    AsyncValue<List<DailyNote>> noteList,
  ) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              _QuickActionTile(
                icon: Icons.add_rounded,
                label: 'Add Event',
                color: AppColors.primary,
                onTap: () {
                  Navigator.pop(ctx);
                  _openEventForm(
                    context: context,
                    eventController: eventController,
                    selectedDate: day,
                  );
                },
              ),
              _QuickActionTile(
                icon: Icons.checklist_rounded,
                label: 'Add Task',
                color: AppColors.sage,
                onTap: () {
                  Navigator.pop(ctx);
                  _openTodoForm(
                    context: context,
                    todoController: todoController,
                    selectedDate: day,
                  );
                },
              ),
              _QuickActionTile(
                icon: Icons.account_balance_wallet_rounded,
                label: 'Add Expense',
                color: AppColors.yellow,
                onTap: () {
                  Navigator.pop(ctx);
                  _openExpenseForm(
                    context: context,
                    expenseController: expenseController,
                    selectedDate: day,
                  );
                },
              ),
              _QuickActionTile(
                icon: Icons.edit_note_rounded,
                label: 'Add Note',
                color: AppColors.lavender,
                onTap: () {
                  Navigator.pop(ctx);
                  final dayNote = (noteList.value ?? const [])
                      .where((n) => AppDateUtils.isSameDate(n.date, day))
                      .firstOrNull;
                  showAppBottomSheet(
                    context: context,
                    child: NotesSheet(
                      selectedDate: day,
                      note: dayNote,
                      onSave: (note) async {
                        await noteController.saveNote(note);
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Helpers (unchanged business logic) ──────────────────────────

  void _confirmLogout(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(authControllerProvider).signOut();
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  String _greeting(String username) {
    final now = DateTime.now();
    final hour = now.hour;
    final timeGreeting =
        hour < 12 ? 'Morning' : hour < 17 ? 'Afternoon' : 'Evening';
    final dateStr = DateFormat('EEEE, MMMM d').format(now);
    return 'Good $timeGreeting, $username  ·  $dateStr';
  }

  String? _monthlySummary(
    DateTime focusedDay,
    List<CalendarEvent> events,
    List<TodoItem> todos,
    List<ExpenseEntry> expenses,
    List<HabitCheckIn> checkIns,
    List<DailyNote> notes,
  ) {
    final month = focusedDay.month;
    final year = focusedDay.year;

    final monthTodos = todos
        .where((t) => t.date.month == month && t.date.year == year)
        .toList();
    final monthEvents = events
        .where((e) {
          final d = e.startAt;
          return d.month == month && d.year == year;
        })
        .length;
    final monthExpenses = expenses
        .where((e) => e.date.month == month && e.date.year == year)
        .toList();

    var net = 0.0;
    for (final e in monthExpenses) {
      net += e.type == ExpenseType.income ? e.amount : -e.amount;
    }

    final monthCheckIns = checkIns
        .where((c) =>
            c.date.month == month && c.date.year == year && c.isDone)
        .length;

    final monthNotes = notes
        .where((n) =>
            n.date.month == month &&
            n.date.year == year &&
            n.content.trim().isNotEmpty)
        .length;

    final parts = <String>[];
    if (monthTodos.isNotEmpty) {
      final done = monthTodos.where((t) => t.isDone).length;
      parts.add('$done/${monthTodos.length} tasks');
    }
    if (monthEvents > 0) parts.add('$monthEvents events');
    if (net != 0) {
      parts.add('${net > 0 ? "+" : ""}${net.toStringAsFixed(0)} net');
    }
    if (monthCheckIns > 0) parts.add('$monthCheckIns habits done');
    if (monthNotes > 0) parts.add('$monthNotes notes');

    return parts.isEmpty ? null : parts.join('  ·  ');
  }

  List<CalendarEvent> _eventsForDay(
      List<CalendarEvent> events, DateTime day) {
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
      return events.length == 1
          ? 'at $time'
          : '${events.length} events, next $time';
    }
    return '${events.length} event${events.length == 1 ? '' : 's'}';
  }

  String _expenseSubtitle(double net, int count) {
    final itemLabel = count == 1 ? 'item' : 'items';
    if (net == 0) return 'Balanced · $count $itemLabel';
    final sign = net > 0 ? '+' : '';
    return '$sign${net.toStringAsFixed(0)} · $count $itemLabel';
  }

  String _taskSubtitle(int done, int total) {
    if (done == total) return 'All $total done!';
    return '$done / $total done';
  }

  String _notePreview(String content) {
    final trimmed = content.trim();
    final wordCount =
        trimmed.isEmpty ? 0 : trimmed.split(RegExp(r'\s+')).length;
    final wordsLabel = '$wordCount word${wordCount == 1 ? '' : 's'}';
    if (trimmed.length <= 22) return '$trimmed  ·  $wordsLabel';
    return '${trimmed.substring(0, 22)}...  ·  $wordsLabel';
  }

  String _habitSubtitle(int checked, int total) {
    if (checked == total) return 'All done today!';
    return '$checked / $total today';
  }

  List<CalendarEvent> _upcomingEvents(List<CalendarEvent> events) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final nextWeek = today.add(const Duration(days: 7));
    return events
        .where((e) {
          final occ = _recurrenceCalculator.occurrenceFor(e, today);
          final d = DateTime(
              occ.startAt.year, occ.startAt.month, occ.startAt.day);
          return d.isAfter(today) &&
              d.isBefore(nextWeek.add(const Duration(days: 1)));
        })
        .map((e) => _recurrenceCalculator.occurrenceFor(e, today))
        .toList()
      ..sort((a, b) => a.startAt.compareTo(b.startAt));
  }

  // ── Form openers ────────────────────────────────────────────────

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
            AppNotification.success(context, 'Event saved');
          }
        },
        onDelete: (event) async {
          await eventController.deleteEvent(event);
          if (context.mounted) {
            Navigator.of(context).pop();
            AppNotification.info(context, 'Event deleted');
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
            AppNotification.success(context, 'Expense saved');
          }
        },
        onDelete: (expense) async {
          await expenseController.deleteExpense(expense);
          if (context.mounted) {
            Navigator.of(context).pop();
            AppNotification.info(context, 'Expense deleted');
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
            AppNotification.success(context, 'Task saved');
          }
        },
      ),
    );
  }

  MoodEntry _createMoodEntry(
    MoodEntry? existing,
    DateTime selectedDate,
    MoodOption mood, {
    required String userId,
    String? note,
  }) {
    final now = DateTime.now();
    return MoodEntry(
      id: existing?.id ??
          '${selectedDate.year}-${selectedDate.month}-${selectedDate.day}',
      userId: existing?.userId ?? userId,
      date: DateTime(selectedDate.year, selectedDate.month, selectedDate.day),
      mood: mood,
      note: note ?? existing?.note ?? '',
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
            AppNotification.success(context, 'Habit saved');
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

// ── Quick-action tile ─────────────────────────────────────────────

class _QuickActionTile extends StatelessWidget {
  const _QuickActionTile({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: color.withValues(alpha: .18),
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
      ),
      onTap: onTap,
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
