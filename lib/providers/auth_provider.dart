import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user_profile.dart';
import '../repositories/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return createAuthRepository(firestore: FirebaseFirestore.instance);
});

final authStateProvider = StreamProvider<UserProfile?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
});

final authControllerProvider = Provider<AuthController>((ref) {
  return AuthController(ref.read(authRepositoryProvider));
});

class AuthController {
  AuthController(this._repository);

  final AuthRepository _repository;

  Future<UserProfile> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) {
    return _repository.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserProfile> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) {
    return _repository.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() {
    return _repository.signOut();
  }
}
