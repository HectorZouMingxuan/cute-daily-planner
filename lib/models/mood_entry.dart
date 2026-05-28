import 'sync_metadata.dart';

enum MoodOption {
  great,
  good,
  okay,
  tired,
  bad;

  String get label => switch (this) {
    MoodOption.great => 'Great',
    MoodOption.good => 'Good',
    MoodOption.okay => 'Okay',
    MoodOption.tired => 'Tired',
    MoodOption.bad => 'Bad',
  };

  String get icon => switch (this) {
    MoodOption.great => 'star',
    MoodOption.good => 'sun',
    MoodOption.okay => 'leaf',
    MoodOption.tired => 'moon',
    MoodOption.bad => 'cloud',
  };
}

class MoodEntry {
  const MoodEntry({
    required this.id,
    required this.userId,
    required this.date,
    required this.mood,
    required this.note,
    required this.createdAt,
    required this.updatedAt,
    required this.syncStatus,
    required this.version,
  });

  final String id;
  final String userId;
  final DateTime date;
  final MoodOption mood;
  final String note;
  final DateTime createdAt;
  final DateTime updatedAt;
  final SyncStatus syncStatus;
  final int version;

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'date': date.toIso8601String(),
    'mood': mood.name,
    'note': note,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'syncStatus': syncStatus.name,
    'version': version,
  };

  factory MoodEntry.fromJson(Map<String, dynamic> json) {
    return MoodEntry(
      id: json['id'] as String,
      userId: json['userId'] as String? ?? 'local-user',
      date: DateTime.parse(json['date'] as String),
      mood: MoodOption.values.firstWhere(
        (value) => value.name == json['mood'],
        orElse: () => MoodOption.okay,
      ),
      note: json['note'] as String? ?? '',
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
