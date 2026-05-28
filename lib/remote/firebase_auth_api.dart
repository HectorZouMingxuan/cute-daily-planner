import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import '../models/user_profile.dart';

class FirebaseAuthApi {
  bool get isConfigured => Firebase.apps.isNotEmpty;

  UserProfile? get currentUser {
    if (!isConfigured) {
      return null;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return null;
    }

    return UserProfile(
      id: user.uid,
      email: user.email ?? '',
      displayName: user.displayName ?? 'Calendar Friend',
    );
  }

  Future<UserProfile> signInAnonymously() async {
    if (!isConfigured) {
      throw StateError('Firebase config is missing');
    }

    final credential = await FirebaseAuth.instance.signInAnonymously();
    final user = credential.user!;
    return UserProfile(
      id: user.uid,
      email: user.email ?? '',
      displayName: user.displayName ?? 'Calendar Friend',
    );
  }

  Future<void> signOut() async {
    if (isConfigured) {
      await FirebaseAuth.instance.signOut();
    }
  }
}
