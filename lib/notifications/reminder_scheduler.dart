import '../models/calendar_event.dart';
import 'notification_service.dart';

class ReminderScheduler {
  ReminderScheduler(this._notificationService);

  final NotificationService _notificationService;

  Future<void> reschedule(CalendarEvent event) {
    return _notificationService.scheduleEventReminders(event);
  }

  Future<void> cancel(CalendarEvent event) {
    return _notificationService.cancelEventReminders(event);
  }
}
