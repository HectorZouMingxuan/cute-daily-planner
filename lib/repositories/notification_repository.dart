import '../models/calendar_event.dart';
import '../notifications/notification_service.dart';
import '../notifications/reminder_scheduler.dart';

class NotificationRepository {
  NotificationRepository(this._scheduler);

  final ReminderScheduler _scheduler;

  Future<void> rescheduleEvent(CalendarEvent event) {
    return _scheduler.reschedule(event);
  }

  Future<void> cancelEvent(CalendarEvent event) {
    return _scheduler.cancel(event);
  }
}

NotificationRepository createNotificationRepository() {
  return NotificationRepository(ReminderScheduler(NotificationService()));
}
