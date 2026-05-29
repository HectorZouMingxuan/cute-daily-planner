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
  }) {
    return _authApi.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
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
