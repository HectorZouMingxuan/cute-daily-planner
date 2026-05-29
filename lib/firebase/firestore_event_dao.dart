import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/calendar_event.dart';

class FirestoreEventDao {
  FirestoreEventDao(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _eventsRef(String userId) {
    return _firestore.collection('users').doc(userId).collection('events');
  }

  Future<List<CalendarEvent>> getEvents(String userId) async {
    final snapshot = await _eventsRef(userId).get();
    return snapshot.docs
        .map((doc) => CalendarEvent.fromJson(doc.data()))
        .where((event) => !event.isDeleted)
        .toList()
      ..sort((a, b) => a.startAt.compareTo(b.startAt));
  }

  Future<void> saveEvent(String userId, CalendarEvent event) async {
    await _eventsRef(userId).doc(event.id).set(event.toJson());
  }
}
