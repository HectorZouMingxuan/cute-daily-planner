import 'sync_metadata.dart';

class HabitCheckIn {
  const HabitCheckIn({
    required this.id,
    required this.habitId,
    required this.userId,
    required this.date,
    required this.isDone,
    required this.createdAt,
    required this.updatedAt,
    required this.syncStatus,
    required this.version,
  });

  final String id;
  final String habitId;
  final String userId;
  final DateTime date;
  final bool isDone;
  final DateTime createdAt;
  final DateTime updatedAt;
  final SyncStatus syncStatus;
  final int version;

  HabitCheckIn copyWith({
    bool? isDone,
    DateTime? updatedAt,
    SyncStatus? syncStatus,
    int? version,
  }) {
    return HabitCheckIn(
      id: id,
      habitId: habitId,
      userId: userId,
      date: date,
      isDone: isDone ?? this.isDone,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      version: version ?? this.version,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'habitId': habitId,
    'userId': userId,
    'date': date.toIso8601String(),
    'isDone': isDone,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'syncStatus': syncStatus.name,
    'version': version,
  };

  factory HabitCheckIn.fromJson(Map<String, dynamic> json) {
    return HabitCheckIn(
      id: json['id'] as String,
      habitId: json['habitId'] as String,
      userId: json['userId'] as String? ?? 'local-user',
      date: DateTime.parse(json['date'] as String),
      isDone: json['isDone'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      syncStatus: SyncStatus.values.firstWhere(
        (value) => value.name == json['syncStatus'],
        orElse: () => SyncStatus.localOnly,
      ),
      version: json['version'] as int? ?? 1,
    );
  }
}
