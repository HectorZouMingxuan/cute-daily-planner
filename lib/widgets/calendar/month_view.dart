import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../models/calendar_event.dart';
import '../../models/mood_entry.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import 'calendar_indicators.dart';

class MonthView extends StatelessWidget {
  const MonthView({
    required this.focusedDay,
    required this.selectedDay,
    required this.eventLoader,
    required this.onDaySelected,
    required this.onEventDropped,
    this.onDayLongPress,
    this.incompleteTaskLoader,
    this.allTasksDoneLoader,
    this.hasEventsLoader,
    this.moodLoader,
    this.expenseNetLoader,
    super.key,
  });

  final DateTime focusedDay;
  final DateTime selectedDay;
  final List<CalendarEvent> Function(DateTime day) eventLoader;
  final void Function(DateTime selectedDay, DateTime focusedDay) onDaySelected;
  final void Function(CalendarEvent event, DateTime targetDay) onEventDropped;
  final void Function(DateTime day)? onDayLongPress;
  final int Function(DateTime day)? incompleteTaskLoader;
  final bool Function(DateTime day)? allTasksDoneLoader;
  final bool Function(DateTime day)? hasEventsLoader;
  final MoodOption? Function(DateTime day)? moodLoader;
  final String? Function(DateTime day)? expenseNetLoader;

  @override
  Widget build(BuildContext context) {
    return TableCalendar<CalendarEvent>(
      firstDay: DateTime.utc(2020),
      lastDay: DateTime.utc(2035, 12, 31),
      focusedDay: focusedDay,
      selectedDayPredicate: (day) => isSameDay(day, selectedDay),
      onDaySelected: onDaySelected,
      eventLoader: eventLoader,
      headerVisible: false,
      daysOfWeekHeight: 34,
      rowHeight: 52,
      calendarStyle: CalendarStyle(
        outsideTextStyle:  TextStyle(color: AppColors.textMuted),
        weekendTextStyle:  TextStyle(color: AppColors.textMain),
        defaultTextStyle:  TextStyle(color: AppColors.textMain),
        todayDecoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: .35),
          borderRadius: BorderRadius.circular(AppRadius.small),
        ),
        selectedDecoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(AppRadius.small),
        ),
        selectedTextStyle: TextStyle(
          color: AppColors.textMain,
          fontWeight: FontWeight.w800,
        ),
        todayTextStyle: TextStyle(
          color: AppColors.textMain,
          fontWeight: FontWeight.w800,
        ),
        cellMargin: const EdgeInsets.all(5),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: TextStyle(
          color: AppColors.textMuted,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
        weekendStyle: TextStyle(
          color: AppColors.textMuted,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
      calendarBuilders: CalendarBuilders(
        defaultBuilder: (context, day, focusedDay) => _DragTargetDayCell(
          day: day,
          isWeekend: day.weekday == DateTime.saturday || day.weekday == DateTime.sunday,
          onEventDropped: onEventDropped,
          onLongPress: onDayLongPress != null ? () => onDayLongPress!(day) : null,
          incompleteCount: incompleteTaskLoader?.call(day) ?? 0,
          allTasksDone: allTasksDoneLoader?.call(day) ?? false,
          hasEvents: hasEventsLoader?.call(day) ?? false,
          mood: moodLoader?.call(day),
          expenseNet: expenseNetLoader?.call(day),
        ),
        todayBuilder: (context, day, focusedDay) => _DragTargetDayCell(
          day: day,
          backgroundColor: AppColors.primary.withValues(alpha: .35),
          textStyle: TextStyle(
            color: AppColors.textMain,
            fontWeight: FontWeight.w800,
          ),
          onEventDropped: onEventDropped,
          onLongPress: onDayLongPress != null ? () => onDayLongPress!(day) : null,
          incompleteCount: incompleteTaskLoader?.call(day) ?? 0,
          allTasksDone: allTasksDoneLoader?.call(day) ?? false,
          hasEvents: hasEventsLoader?.call(day) ?? false,
          mood: moodLoader?.call(day),
          expenseNet: expenseNetLoader?.call(day),
        ),
        selectedBuilder: (context, day, focusedDay) => _DragTargetDayCell(
          day: day,
          backgroundColor: AppColors.primary,
          textStyle: TextStyle(
            color: AppColors.textMain,
            fontWeight: FontWeight.w800,
          ),
          onEventDropped: onEventDropped,
          onLongPress: onDayLongPress != null ? () => onDayLongPress!(day) : null,
          incompleteCount: incompleteTaskLoader?.call(day) ?? 0,
          allTasksDone: allTasksDoneLoader?.call(day) ?? false,
          hasEvents: hasEventsLoader?.call(day) ?? false,
          mood: moodLoader?.call(day),
          expenseNet: expenseNetLoader?.call(day),
        ),
        outsideBuilder: (context, day, focusedDay) => _DragTargetDayCell(
          day: day,
          isWeekend: day.weekday == DateTime.saturday || day.weekday == DateTime.sunday,
          textStyle:  TextStyle(color: AppColors.textMuted),
          onEventDropped: onEventDropped,
          onLongPress: onDayLongPress != null ? () => onDayLongPress!(day) : null,
          incompleteCount: incompleteTaskLoader?.call(day) ?? 0,
          allTasksDone: allTasksDoneLoader?.call(day) ?? false,
          hasEvents: hasEventsLoader?.call(day) ?? false,
          mood: moodLoader?.call(day),
          expenseNet: expenseNetLoader?.call(day),
        ),
        dowBuilder: (context, day) {
          const letters = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
          final isTodayDow = day.weekday == DateTime.now().weekday;
          return Center(
            child: Text(
              letters[day.weekday - 1],
              style: TextStyle(
                color: isTodayDow ? AppColors.primary : AppColors.textMuted,
                fontWeight: isTodayDow ? FontWeight.w900 : FontWeight.w700,
                fontSize: 12,
              ),
            ),
          );
        },
        markerBuilder: (context, day, events) {
          if (events.isEmpty) {
            return const SizedBox.shrink();
          }

          return Positioned(
            bottom: 5,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: events.take(3).map((event) {
                return Container(
                  width: 5,
                  height: 5,
                  margin: const EdgeInsets.symmetric(horizontal: 1.5),
                  decoration: BoxDecoration(
                    color: Color(event.color),
                    shape: BoxShape.circle,
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}

class _DragTargetDayCell extends StatelessWidget {
  const _DragTargetDayCell({
    required this.day,
    required this.onEventDropped,
    this.backgroundColor,
    this.textStyle,
    this.onLongPress,
    this.isWeekend = false,
    this.incompleteCount = 0,
    this.allTasksDone = false,
    this.hasEvents = false,
    this.mood,
    this.expenseNet,
  });

  final DateTime day;
  final Color? backgroundColor;
  final TextStyle? textStyle;
  final void Function(CalendarEvent event, DateTime targetDay) onEventDropped;
  final VoidCallback? onLongPress;
  final bool isWeekend;
  final int incompleteCount;
  final bool allTasksDone;
  final bool hasEvents;
  final MoodOption? mood;
  final String? expenseNet;

  @override
  Widget build(BuildContext context) {
    final hasExpense = expenseNet != null;
    final hasTask = incompleteCount > 0 || allTasksDone;
    final effectiveBg = backgroundColor ?? (isWeekend ? AppColors.primarySoft.withValues(alpha: .25) : null);

    return GestureDetector(
      onLongPress: onLongPress,
      child: DragTarget<CalendarEvent>(
        onAcceptWithDetails: (details) => onEventDropped(details.data, day),
        builder: (context, candidateData, rejectedData) {
          final highlighted = candidateData.isNotEmpty;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            margin: const EdgeInsets.all(5),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: highlighted
                  ? AppColors.mint.withValues(alpha: .45)
                  : effectiveBg,
              borderRadius: BorderRadius.circular(AppRadius.small),
              border: highlighted
                  ? Border.all(color: AppColors.mint, width: 2)
                  : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${day.day}',
                  style:
                      textStyle ??  TextStyle(color: AppColors.textMain),
                ),
                if (hasTask || mood != null || hasExpense || hasEvents)
                  Padding(
                    padding: const EdgeInsets.only(top: 1),
                    child: Wrap(
                      spacing: 2,
                      runSpacing: 1,
                      alignment: WrapAlignment.center,
                      children: [
                        if (incompleteCount > 0)
                          TaskCountBadge(count: incompleteCount),
                        if (allTasksDone) const CheckMark(),
                        if (mood != null) MoodEmoji(mood: mood!),
                        if (hasExpense && expenseNet!.startsWith('+'))
                          ExpenseLabel(
                              total: expenseNet!, color: AppColors.mint),
                        if (hasExpense && expenseNet!.startsWith('-'))
                          ExpenseLabel(
                              total: expenseNet!, color: AppColors.danger),
                        if (hasEvents) const EventBadge(),
                      ],
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
