import 'sync_metadata.dart';

enum TodoPriority {
  low,
  medium,
  high;

  String get label => switch (this) {
    TodoPriority.low => 'Low',
    TodoPriority.medium => 'Medium',
    TodoPriority.high => 'High',
  };
}

class TodoItem {
  const TodoItem({
    required this.id,
    required this.userId,
    required this.title,
    required this.date,
    required this.isDone,
    required this.priority,
    required this.createdAt,
    required this.updatedAt,
    required this.syncStatus,
    required this.version,
    this.deletedAt,
  });

  final String id;
  final String userId;
  final String title;
  final DateTime date;
  final bool isDone;
  final TodoPriority priority;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final SyncStatus syncStatus;
  final int version;

  bool get isDeleted => deletedAt != null;

  TodoItem copyWith({
    String? title,
    DateTime? date,
    bool? isDone,
    TodoPriority? priority,
    DateTime? updatedAt,
    DateTime? deletedAt,
    SyncStatus? syncStatus,
    int? version,
  }) {
    return TodoItem(
      id: id,
      userId: userId,
      title: title ?? this.title,
      date: date ?? this.date,
      isDone: isDone ?? this.isDone,
      priority: priority ?? this.priority,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      version: version ?? this.version,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'title': title,
    'date': date.toIso8601String(),
    'isDone': isDone,
    'priority': priority.name,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'deletedAt': deletedAt?.toIso8601String(),
    'syncStatus': syncStatus.name,
    'version': version,
  };

  factory TodoItem.fromJson(Map<String, dynamic> json) {
    return TodoItem(
      id: json['id'] as String,
      userId: json['userId'] as String? ?? 'local-user',
      title: json['title'] as String? ?? '',
      date: DateTime.parse(json['date'] as String),
      isDone: json['isDone'] as bool? ?? false,
      priority: TodoPriority.values.firstWhere(
        (value) => value.name == json['priority'],
        orElse: () => TodoPriority.medium,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      deletedAt: json['deletedAt'] == null
          ? null
          : DateTime.tryParse(json['deletedAt'] as String),
      syncStatus: SyncStatus.values.firstWhere(
        (value) => value.name == json['syncStatus'],
        orElse: () => SyncStatus.localOnly,
      ),
      version: json['version'] as int? ?? 1,
    );
  }
}
