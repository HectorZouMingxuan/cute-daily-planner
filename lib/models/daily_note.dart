import 'sync_metadata.dart';

class DailyNote {
  const DailyNote({
    required this.id,
    required this.userId,
    required this.date,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.syncStatus,
    required this.version,
    this.deletedAt,
  });

  final String id;
  final String userId;
  final DateTime date;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final SyncStatus syncStatus;
  final int version;

  bool get isDeleted => deletedAt != null;

  DailyNote copyWith({
    String? content,
    DateTime? updatedAt,
    DateTime? deletedAt,
    SyncStatus? syncStatus,
    int? version,
  }) {
    return DailyNote(
      id: id,
      userId: userId,
      date: date,
      content: content ?? this.content,
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
    'date': date.toIso8601String(),
    'content': content,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'deletedAt': deletedAt?.toIso8601String(),
    'syncStatus': syncStatus.name,
    'version': version,
  };

  factory DailyNote.fromJson(Map<String, dynamic> json) {
    return DailyNote(
      id: json['id'] as String,
      userId: json['userId'] as String? ?? 'local-user',
      date: DateTime.parse(json['date'] as String),
      content: json['content'] as String? ?? '',
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
