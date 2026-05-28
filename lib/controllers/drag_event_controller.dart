import '../models/calendar_event.dart';

class DragEventController {
  const DragEventController();

  CalendarEvent moveEventToDay(CalendarEvent event, DateTime targetDay) {
    final duration = event.endAt.difference(event.startAt);
    final newStartAt = DateTime(
      targetDay.year,
      targetDay.month,
      targetDay.day,
      event.startAt.hour,
      event.startAt.minute,
    );

    return event.copyWith(
      startAt: newStartAt,
      endAt: newStartAt.add(duration),
      updatedAt: DateTime.now(),
      version: event.version + 1,
    );
  }
}
