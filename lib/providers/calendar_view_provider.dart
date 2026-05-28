import 'package:flutter_riverpod/flutter_riverpod.dart';

class CalendarViewState {
  const CalendarViewState({
    required this.focusedDay,
    required this.selectedDay,
  });

  final DateTime focusedDay;
  final DateTime selectedDay;

  CalendarViewState copyWith({DateTime? focusedDay, DateTime? selectedDay}) {
    return CalendarViewState(
      focusedDay: focusedDay ?? this.focusedDay,
      selectedDay: selectedDay ?? this.selectedDay,
    );
  }
}

class CalendarViewController extends Notifier<CalendarViewState> {
  @override
  CalendarViewState build() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return CalendarViewState(focusedDay: today, selectedDay: today);
  }

  void selectDay(DateTime selectedDay, DateTime focusedDay) {
    state = state.copyWith(
      selectedDay: _dateOnly(selectedDay),
      focusedDay: focusedDay,
    );
  }

  void goToToday() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    state = CalendarViewState(focusedDay: today, selectedDay: today);
  }

  void goToPreviousMonth() {
    final current = state.focusedDay;
    state = state.copyWith(
      focusedDay: DateTime(current.year, current.month - 1),
    );
  }

  void goToNextMonth() {
    final current = state.focusedDay;
    state = state.copyWith(
      focusedDay: DateTime(current.year, current.month + 1),
    );
  }

  DateTime _dateOnly(DateTime date) =>
      DateTime(date.year, date.month, date.day);
}

final calendarViewProvider =
    NotifierProvider<CalendarViewController, CalendarViewState>(
      CalendarViewController.new,
    );
