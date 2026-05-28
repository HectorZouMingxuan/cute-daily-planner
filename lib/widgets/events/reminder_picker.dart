import 'package:flutter/material.dart';

import '../../models/event_reminder.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';

const reminderOptions = <EventReminder>[
  EventReminder(minutesBefore: -1),
  EventReminder(minutesBefore: 0),
  EventReminder(minutesBefore: 5),
  EventReminder(minutesBefore: 10),
  EventReminder(minutesBefore: 30),
  EventReminder(minutesBefore: 60),
  EventReminder(minutesBefore: 1440),
];

class ReminderPicker extends StatelessWidget {
  const ReminderPicker({
    required this.selectedReminder,
    required this.onChanged,
    super.key,
  });

  final EventReminder selectedReminder;
  final ValueChanged<EventReminder> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Reminder', style: AppTextStyles.body),
        const SizedBox(height: AppSpacing.sm),
        DropdownButtonFormField<int>(
          initialValue: selectedReminder.minutesBefore,
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.notifications_none_rounded),
          ),
          items: reminderOptions
              .map(
                (reminder) => DropdownMenuItem<int>(
                  value: reminder.minutesBefore,
                  child: Text(reminder.label),
                ),
              )
              .toList(),
          onChanged: (value) {
            if (value != null) {
              onChanged(EventReminder(minutesBefore: value));
            }
          },
        ),
      ],
    );
  }
}
