import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as timezone_data;
import 'package:timezone/timezone.dart' as timezone;

import '../models/calendar_event.dart';

class NotificationService {
  NotificationService();

  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    if (kIsWeb) {
      return;
    }

    timezone_data.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const darwinSettings = DarwinInitializationSettings();
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
      macOS: darwinSettings,
    );

    await _plugin.initialize(settings: settings);
  }

  Future<void> scheduleEventReminders(CalendarEvent event) async {
    if (kIsWeb || event.reminders.isEmpty) {
      return;
    }

    await cancelEventReminders(event);

    for (final reminder in event.reminders) {
      if (reminder.minutesBefore < 0) {
        continue;
      }

      final scheduledAt = event.startAt.subtract(
        Duration(minutes: reminder.minutesBefore),
      );
      if (scheduledAt.isBefore(DateTime.now())) {
        continue;
      }

      await _plugin.zonedSchedule(
        id: _notificationId(event.id, reminder.minutesBefore),
        title: event.title,
        body: reminder.label,
        scheduledDate: timezone.TZDateTime.from(scheduledAt, timezone.local),
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            'event_reminders',
            'Event Reminders',
            channelDescription: 'Reminders for calendar events',
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
          macOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      );
    }
  }

  Future<void> cancelEventReminders(CalendarEvent event) async {
    if (kIsWeb) {
      return;
    }

    for (final reminder in event.reminders) {
      await _plugin.cancel(
        id: _notificationId(event.id, reminder.minutesBefore),
      );
    }
  }

  int _notificationId(String eventId, int minutesBefore) {
    return Object.hash(eventId, minutesBefore) & 0x7fffffff;
  }
}
