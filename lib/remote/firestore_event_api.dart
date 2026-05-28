import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import '../models/calendar_event.dart';

class FirestoreEventApi {
  bool get isConfigured => Firebase.apps.isNotEmpty;

  Future<void> upsertEvent(CalendarEvent event) async {
    if (!isConfigured) {
      throw StateError('Firebase config is missing');
    }

    await FirebaseFirestore.instance
        .collection('users')
        .doc(event.userId)
        .collection('events')
        .doc(event.id)
        .set(event.toJson(), SetOptions(merge: true));
  }
}
