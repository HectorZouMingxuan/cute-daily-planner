import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

class CurrentUserId extends Notifier<String> {
  @override
  String build() => 'local-user';

  void set(String id) => state = id;
}

final currentUserIdProvider = NotifierProvider<CurrentUserId, String>(CurrentUserId.new);
