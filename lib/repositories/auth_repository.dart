import '../models/user_profile.dart';
import '../remote/firebase_auth_api.dart';

class AuthRepository {
  AuthRepository(this._authApi);

  final FirebaseAuthApi _authApi;

  bool get isConfigured => _authApi.isConfigured;

  UserProfile? get currentUser => _authApi.currentUser;

  Future<UserProfile> signInAnonymously() {
    return _authApi.signInAnonymously();
  }

  Future<void> signOut() {
    return _authApi.signOut();
  }
}

AuthRepository createAuthRepository() {
  return AuthRepository(FirebaseAuthApi());
}
