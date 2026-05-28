import 'package:hive_flutter/hive_flutter.dart';

class LocalDatabase {
  static const eventsBoxName = 'calendar_events';

  Future<Box<Map>> openEventsBox() {
    return Hive.openBox<Map>(eventsBoxName);
  }
}
