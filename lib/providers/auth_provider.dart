import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user_profile.dart';
import '../repositories/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return createAuthRepository();
});

final authProvider = AsyncNotifierProvider<AuthController, UserProfile?>(
  AuthController.new,
);

class AuthController extends AsyncNotifier<UserProfile?> {
  AuthRepository get _repository => ref.read(authRepositoryProvider);

  @override
  Future<UserProfile?> build() async {
    return _repository.currentUser;
  }

  Future<void> signInAnonymously() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_repository.signInAnonymously);
  }

  Future<void> signOut() async {
    await _repository.signOut();
    state = const AsyncData(null);
  }
}
