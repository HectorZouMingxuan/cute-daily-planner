import 'event_reminder.dart';
import 'recurrence_rule.dart';
import 'sync_metadata.dart';

class CalendarEvent {
  const CalendarEvent({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.location,
    required this.startAt,
    required this.endAt,
    required this.isAllDay,
    required this.color,
    required this.reminders,
    required this.recurrenceRule,
    required this.createdAt,
    required this.updatedAt,
    required this.syncStatus,
    required this.version,
    this.deletedAt,
  });

  final String id;
  final String userId;
  final String title;
  final String description;
  final String location;
  final DateTime startAt;
  final DateTime endAt;
  final bool isAllDay;
  final int color;
  final List<EventReminder> reminders;
  final RecurrenceRule recurrenceRule;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final SyncStatus syncStatus;
  final int version;

  bool get isDeleted => deletedAt != null;

  CalendarEvent copyWith({
    String? id,
    String? userId,
    String? title,
    String? description,
    String? location,
    DateTime? startAt,
    DateTime? endAt,
    bool? isAllDay,
    int? color,
    List<EventReminder>? reminders,
    RecurrenceRule? recurrenceRule,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    bool clearDeletedAt = false,
    SyncStatus? syncStatus,
    int? version,
  }) {
    return CalendarEvent(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      location: location ?? this.location,
      startAt: startAt ?? this.startAt,
      endAt: endAt ?? this.endAt,
      isAllDay: isAllDay ?? this.isAllDay,
      color: color ?? this.color,
      reminders: reminders ?? this.reminders,
      recurrenceRule: recurrenceRule ?? this.recurrenceRule,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: clearDeletedAt ? null : deletedAt ?? this.deletedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      version: version ?? this.version,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'description': description,
      'location': location,
      'startAt': startAt.toIso8601String(),
      'endAt': endAt.toIso8601String(),
      'isAllDay': isAllDay,
      'color': color,
      'reminders': reminders.map((reminder) => reminder.toJson()).toList(),
      'recurrenceRule': recurrenceRule.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'deletedAt': deletedAt?.toIso8601String(),
      'syncStatus': syncStatus.name,
      'version': version,
    };
  }

  factory CalendarEvent.fromJson(Map<String, dynamic> json) {
    final syncStatusName = json['syncStatus'] as String? ?? 'localOnly';
    final syncStatus = SyncStatus.values.firstWhere(
      (value) => value.name == syncStatusName,
      orElse: () => SyncStatus.localOnly,
    );

    final remindersJson = json['reminders'] as List<dynamic>? ?? [];

    return CalendarEvent(
      id: json['id'] as String,
      userId: json['userId'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      location: json['location'] as String? ?? '',
      startAt: DateTime.parse(json['startAt'] as String),
      endAt: DateTime.parse(json['endAt'] as String),
      isAllDay: json['isAllDay'] as bool? ?? false,
      color: json['color'] as int? ?? 0xFF7CC8FF,
      reminders: remindersJson
          .map(
            (item) =>
                EventReminder.fromJson(Map<String, dynamic>.from(item as Map)),
          )
          .toList(),
      recurrenceRule: RecurrenceRule.fromJson(
        json['recurrenceRule'] == null
            ? null
            : Map<String, dynamic>.from(json['recurrenceRule'] as Map),
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      deletedAt: json['deletedAt'] == null
          ? null
          : DateTime.tryParse(json['deletedAt'] as String),
      syncStatus: syncStatus,
      version: json['version'] as int? ?? 1,
    );
  }
}
