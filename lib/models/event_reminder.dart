class EventReminder {
  const EventReminder({required this.minutesBefore});

  final int minutesBefore;

  String get label {
    return switch (minutesBefore) {
      -1 => 'No reminder',
      0 => 'At time of event',
      5 => '5 minutes before',
      10 => '10 minutes before',
      30 => '30 minutes before',
      60 => '1 hour before',
      1440 => '1 day before',
      _ => '$minutesBefore minutes before',
    };
  }

  Map<String, dynamic> toJson() => {'minutesBefore': minutesBefore};

  factory EventReminder.fromJson(Map<String, dynamic> json) {
    return EventReminder(minutesBefore: json['minutesBefore'] as int? ?? -1);
  }
}
