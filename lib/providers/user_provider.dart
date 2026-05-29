import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_provider.dart';

final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

final currentUserIdProvider = Provider<String>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.asData?.value?.id ?? 'local-user';
});
