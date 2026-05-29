class UserProfile {
  const UserProfile({
    required this.id,
    required this.email,
    required this.displayName,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String email;
  final String displayName;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserProfile copyWith({
    String? id,
    String? email,
    String? displayName,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'email': email,
        'displayName': displayName,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };
}
