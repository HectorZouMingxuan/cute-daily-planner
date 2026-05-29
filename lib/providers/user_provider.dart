import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../remote/firestore_planner_api.dart';
import 'auth_provider.dart';

final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

final firestorePlannerApiProvider = Provider<FirestorePlannerApi>((ref) {
  return FirestorePlannerApi();
});

final currentUserIdProvider = Provider<String>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.asData?.value?.id ?? 'local-user';
});
