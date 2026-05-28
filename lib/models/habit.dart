import 'sync_metadata.dart';

class Habit {
  const Habit({
    required this.id,
    required this.userId,
    required this.title,
    required this.icon,
    required this.color,
    required this.createdAt,
    required this.updatedAt,
    required this.syncStatus,
    required this.version,
    this.deletedAt,
  });

  final String id;
  final String userId;
  final String title;
  final String icon;
  final int color;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final SyncStatus syncStatus;
  final int version;

  bool get isDeleted => deletedAt != null;

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'title': title,
    'icon': icon,
    'color': color,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'deletedAt': deletedAt?.toIso8601String(),
    'syncStatus': syncStatus.name,
    'version': version,
  };

  factory Habit.fromJson(Map<String, dynamic> json) {
    return Habit(
      id: json['id'] as String,
      userId: json['userId'] as String? ?? 'local-user',
      title: json['title'] as String? ?? '',
      icon: json['icon'] as String? ?? 'check',
      color: json['color'] as int? ?? 0xFFA7E8BD,
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
