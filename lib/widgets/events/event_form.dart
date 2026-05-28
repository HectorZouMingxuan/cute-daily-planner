import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../models/calendar_event.dart';
import '../../models/event_reminder.dart';
import '../../models/recurrence_rule.dart';
import '../../models/sync_metadata.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';
import 'color_picker.dart';
import 'recurrence_picker.dart';
import 'reminder_picker.dart';

class EventForm extends StatefulWidget {
  const EventForm({
    required this.selectedDate,
    required this.onSave,
    super.key,
    this.event,
    this.onDelete,
  });

  final DateTime selectedDate;
  final CalendarEvent? event;
  final ValueChanged<CalendarEvent> onSave;
  final ValueChanged<CalendarEvent>? onDelete;

  @override
  State<EventForm> createState() => _EventFormState();
}

class _EventFormState extends State<EventForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();

  late DateTime _startAt;
  late DateTime _endAt;
  late bool _isAllDay;
  late Color _color;
  late EventReminder _reminder;
  late RecurrenceRule _recurrenceRule;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    final event = widget.event;
    final baseDate = widget.selectedDate;
    _titleController.text = event?.title ?? '';
    _descriptionController.text = event?.description ?? '';
    _locationController.text = event?.location ?? '';
    _startAt =
        event?.startAt ??
        DateTime(baseDate.year, baseDate.month, baseDate.day, 9);
    _endAt = event?.endAt ?? _startAt.add(const Duration(hours: 1));
    _isAllDay = event?.isAllDay ?? false;
    _color = event == null ? AppColors.primary : Color(event.color);
    _reminder =
        event?.reminders.firstOrNull ?? const EventReminder(minutesBefore: -1);
    _recurrenceRule = event?.recurrenceRule ?? const RecurrenceRule();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final editing = widget.event != null;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 12, 20, bottomInset + 20),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                editing ? 'Edit Event' : 'Add Event',
                style: AppTextStyles.title,
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: _titleController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Title is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.sm),
              TextFormField(
                controller: _locationController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: 'Location'),
              ),
              const SizedBox(height: AppSpacing.sm),
              TextFormField(
                controller: _descriptionController,
                minLines: 2,
                maxLines: 4,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              const SizedBox(height: AppSpacing.md),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('All Day'),
                value: _isAllDay,
                onChanged: (value) => setState(() => _isAllDay = value),
              ),
              _DateTimeTile(
                label: 'Start Time',
                value: _formatDateTime(_startAt),
                onTap: () => _pickDateTime(isStart: true),
              ),
              _DateTimeTile(
                label: 'End Time',
                value: _formatDateTime(_endAt),
                onTap: () => _pickDateTime(isStart: false),
              ),
              const SizedBox(height: AppSpacing.md),
              const Text('Color', style: AppTextStyles.body),
              const SizedBox(height: AppSpacing.sm),
              ColorPicker(
                selectedColor: _color,
                onChanged: (color) => setState(() => _color = color),
              ),
              const SizedBox(height: AppSpacing.md),
              ReminderPicker(
                selectedReminder: _reminder,
                onChanged: (reminder) => setState(() => _reminder = reminder),
              ),
              const SizedBox(height: AppSpacing.md),
              RecurrencePicker(
                selectedRule: _recurrenceRule,
                onChanged: (rule) => setState(() => _recurrenceRule = rule),
              ),
              if (_errorText != null) ...[
                const SizedBox(height: AppSpacing.md),
                Text(
                  _errorText!,
                  style: const TextStyle(
                    color: AppColors.danger,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  if (editing)
                    TextButton.icon(
                      onPressed: _delete,
                      icon: const Icon(Icons.delete_outline_rounded),
                      label: const Text('Delete Event'),
                    ),
                  const Spacer(),
                  FilledButton(onPressed: _save, child: const Text('Save')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    if (_isAllDay) {
      return DateFormat('MMM d, yyyy').format(dateTime);
    }
    return DateFormat('MMM d, yyyy, h:mm a').format(dateTime);
  }

  Future<void> _pickDateTime({required bool isStart}) async {
    final current = isStart ? _startAt : _endAt;
    final date = await showDatePicker(
      context: context,
      initialDate: current,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (date == null || !mounted) {
      return;
    }

    var time = TimeOfDay.fromDateTime(current);
    if (!_isAllDay) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: time,
      );
      if (pickedTime == null) {
        return;
      }
      time = pickedTime;
    }

    final updated = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
    setState(() {
      if (isStart) {
        final duration = _endAt.difference(_startAt);
        _startAt = updated;
        _endAt = updated.add(
          duration.isNegative ? const Duration(hours: 1) : duration,
        );
      } else {
        _endAt = updated;
      }
    });
  }

  void _save() {
    setState(() => _errorText = null);
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (!_endAt.isAfter(_startAt)) {
      setState(() => _errorText = 'End time must be after start time');
      return;
    }

    final now = DateTime.now();
    final existing = widget.event;
    final event = CalendarEvent(
      id: existing?.id ?? const Uuid().v4(),
      userId: existing?.userId ?? 'local-user',
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      location: _locationController.text.trim(),
      startAt: _startAt,
      endAt: _endAt,
      isAllDay: _isAllDay,
      color: _color.toARGB32(),
      reminders: _reminder.minutesBefore < 0 ? const [] : [_reminder],
      recurrenceRule: _recurrenceRule,
      createdAt: existing?.createdAt ?? now,
      updatedAt: now,
      syncStatus: SyncStatus.localOnly,
      version: (existing?.version ?? 0) + 1,
    );

    widget.onSave(event);
  }

  void _delete() {
    final event = widget.event;
    if (event != null && widget.onDelete != null) {
      widget.onDelete!(event);
    }
  }
}

class _DateTimeTile extends StatelessWidget {
  const _DateTimeTile({
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label),
      subtitle: Text(value),
      trailing: const Icon(Icons.chevron_right_rounded),
      onTap: onTap,
    );
  }
}
