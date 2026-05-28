import '../models/calendar_event.dart';
import '../models/recurrence_rule.dart';

class RecurrenceCalculator {
  const RecurrenceCalculator();

  bool occursOn(CalendarEvent event, DateTime day) {
    final targetDay = _dateOnly(day);
    final startDay = _dateOnly(event.startAt);

    if (targetDay == startDay) {
      return true;
    }

    final rule = event.recurrenceRule;
    if (!rule.repeats || targetDay.isBefore(startDay)) {
      return false;
    }

    final endDate = rule.endDate;
    if (endDate != null && targetDay.isAfter(_dateOnly(endDate))) {
      return false;
    }

    return switch (rule.frequency) {
      RecurrenceFrequency.none => false,
      RecurrenceFrequency.daily => _matchesDaily(
        startDay,
        targetDay,
        rule.interval,
      ),
      RecurrenceFrequency.weekly => _matchesWeekly(
        startDay,
        targetDay,
        rule.interval,
      ),
      RecurrenceFrequency.monthly => _matchesMonthly(
        startDay,
        targetDay,
        rule.interval,
      ),
      RecurrenceFrequency.yearly => _matchesYearly(
        startDay,
        targetDay,
        rule.interval,
      ),
    };
  }

  CalendarEvent occurrenceFor(CalendarEvent event, DateTime day) {
    final targetDay = _dateOnly(day);
    final duration = event.endAt.difference(event.startAt);
    final startAt = DateTime(
      targetDay.year,
      targetDay.month,
      targetDay.day,
      event.startAt.hour,
      event.startAt.minute,
    );

    return event.copyWith(startAt: startAt, endAt: startAt.add(duration));
  }

  bool _matchesDaily(DateTime startDay, DateTime targetDay, int interval) {
    final days = targetDay.difference(startDay).inDays;
    return days % interval == 0;
  }

  bool _matchesWeekly(DateTime startDay, DateTime targetDay, int interval) {
    final days = targetDay.difference(startDay).inDays;
    return startDay.weekday == targetDay.weekday && (days ~/ 7) % interval == 0;
  }

  bool _matchesMonthly(DateTime startDay, DateTime targetDay, int interval) {
    final months =
        (targetDay.year - startDay.year) * 12 +
        targetDay.month -
        startDay.month;
    return startDay.day == targetDay.day && months % interval == 0;
  }

  bool _matchesYearly(DateTime startDay, DateTime targetDay, int interval) {
    final years = targetDay.year - startDay.year;
    return startDay.month == targetDay.month &&
        startDay.day == targetDay.day &&
        years % interval == 0;
  }

  DateTime _dateOnly(DateTime date) =>
      DateTime(date.year, date.month, date.day);
}
