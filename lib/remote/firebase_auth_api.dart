import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import '../models/user_profile.dart';

class FirebaseAuthApi {
  bool get isConfigured => Firebase.apps.isNotEmpty;

  UserProfile? get currentUser {
    if (!isConfigured) return null;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    return UserProfile(
      id: user.uid,
      email: user.email ?? '',
      displayName: user.displayName ?? emailPrefix(user.email),
    );
  }

  Stream<UserProfile?> get authStateChanges {
    if (!isConfigured) {
      return Stream.value(null);
    }

    return FirebaseAuth.instance.authStateChanges().map((user) {
      if (user == null) return null;
      return UserProfile(
        id: user.uid,
        email: user.email ?? '',
        displayName: user.displayName ?? emailPrefix(user.email),
      );
    });
  }

  Future<UserProfile> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    if (!isConfigured) {
      throw StateError('Firebase config is missing');
    }

    final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = credential.user!;
    return UserProfile(
      id: user.uid,
      email: user.email ?? '',
      displayName: user.displayName ?? emailPrefix(user.email),
    );
  }

  Future<UserProfile> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    if (!isConfigured) {
      throw StateError('Firebase config is missing');
    }

    final credential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = credential.user!;
    return UserProfile(
      id: user.uid,
      email: user.email ?? '',
      displayName: emailPrefix(user.email),
    );
  }

  Future<void> signOut() async {
    if (isConfigured) {
      await FirebaseAuth.instance.signOut();
    }
  }

  static String emailPrefix(String? email) {
    if (email == null || email.isEmpty) return 'Calendar Friend';
    return email.split('@').first;
  }
}
