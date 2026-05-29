import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_profile.dart';
import '../remote/firebase_auth_api.dart';

class AuthRepository {
  AuthRepository(this._authApi, {FirebaseFirestore? firestore})
      : _firestore = firestore;

  final FirebaseAuthApi _authApi;
  final FirebaseFirestore? _firestore;

  bool get isConfigured => _authApi.isConfigured;
  UserProfile? get currentUser => _authApi.currentUser;
  Stream<UserProfile?> get authStateChanges => _authApi.authStateChanges;

  Future<UserProfile> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final profile = await _authApi.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final stored = await _readProfile(profile.id);
    return stored ?? profile;
  }

  Future<UserProfile> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final profile = await _authApi.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await _upsertProfile(profile);
    return profile;
  }

  Future<void> signOut() {
    return _authApi.signOut();
  }

  Future<void> saveDarkModePreference({
    required String userId,
    required bool darkModeEnabled,
  }) async {
    final firestore = _firestore;
    if (firestore == null) return;

    try {
      await firestore.collection('users').doc(userId).set({
        'darkModeEnabled': darkModeEnabled,
        'updatedAt': DateTime.now().toIso8601String(),
      }, SetOptions(merge: true));
    } catch (_) {
      // Non-critical write
    }
  }

  Future<UserProfile?> _readProfile(String userId) async {
    final firestore = _firestore;
    if (firestore == null) return null;

    try {
      final doc = await firestore.collection('users').doc(userId).get();
      if (!doc.exists) return null;
      final data = doc.data()!;
      return UserProfile(
        id: userId,
        email: data['email'] as String? ?? '',
        displayName: data['displayName'] as String? ?? '',
        darkModeEnabled: data['darkModeEnabled'] as bool? ?? false,
        createdAt: _parseDateTime(data['createdAt']),
        updatedAt: _parseDateTime(data['updatedAt']),
      );
    } catch (_) {
      return null;
    }
  }

  DateTime? _parseDateTime(dynamic value) {
    if (value is String) return DateTime.tryParse(value);
    return null;
  }

  Future<void> _upsertProfile(UserProfile profile) async {
    final firestore = _firestore;
    if (firestore == null) return;

    final now = DateTime.now();
    try {
      await firestore
          .collection('users')
          .doc(profile.id)
          .set(profile.copyWith(createdAt: now, updatedAt: now).toJson(),
              SetOptions(merge: true));
    } catch (_) {
      // Profile write is non-critical
    }
  }
}

AuthRepository createAuthRepository({FirebaseFirestore? firestore}) {
  return AuthRepository(FirebaseAuthApi(), firestore: firestore);
}
