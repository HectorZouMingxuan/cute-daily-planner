enum RecurrenceFrequency { none, daily, weekly, monthly, yearly }

class RecurrenceRule {
  const RecurrenceRule({
    this.frequency = RecurrenceFrequency.none,
    this.interval = 1,
    this.endDate,
  });

  final RecurrenceFrequency frequency;
  final int interval;
  final DateTime? endDate;

  bool get repeats => frequency != RecurrenceFrequency.none;

  String get label {
    return switch (frequency) {
      RecurrenceFrequency.none => 'Does not repeat',
      RecurrenceFrequency.daily => 'Daily',
      RecurrenceFrequency.weekly => 'Weekly',
      RecurrenceFrequency.monthly => 'Monthly',
      RecurrenceFrequency.yearly => 'Yearly',
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'frequency': frequency.name,
      'interval': interval,
      'endDate': endDate?.toIso8601String(),
    };
  }

  factory RecurrenceRule.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const RecurrenceRule();
    }

    final frequencyName = json['frequency'] as String? ?? 'none';
    final frequency = RecurrenceFrequency.values.firstWhere(
      (value) => value.name == frequencyName,
      orElse: () => RecurrenceFrequency.none,
    );

    return RecurrenceRule(
      frequency: frequency,
      interval: json['interval'] as int? ?? 1,
      endDate: json['endDate'] == null
          ? null
          : DateTime.tryParse(json['endDate'] as String),
    );
  }
}
