import 'package:flutter/material.dart';

import '../../models/mood_entry.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';

class MoodTrendRow extends StatelessWidget {
  const MoodTrendRow({required this.moods, required this.selectedDate, super.key});

  final List<MoodEntry> moods;
  final DateTime selectedDate;

  static const _dayLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  Widget build(BuildContext context) {
    final last7 = List.generate(7, (i) {
      final day = selectedDate.subtract(Duration(days: 6 - i));
      return moods
          .where((m) =>
              m.date.year == day.year &&
              m.date.month == day.month &&
              m.date.day == day.day)
          .firstOrNull;
    });

    final hasAnyMood = last7.any((m) => m != null);
    if (!hasAnyMood) return const SizedBox.shrink();

    final todayIndex = 6; // today is the last item

    return Container(
      margin: const EdgeInsets.only(top: AppSpacing.sm),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.primarySoft.withValues(alpha: .35),
        borderRadius: BorderRadius.circular(AppRadius.small),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(7, (i) {
              final entry = last7[i];
              final isToday = i == todayIndex;

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    entry?.mood.emoji ?? '·',
                    style: TextStyle(
                      fontSize: 18,
                      color: entry == null ? AppColors.textMuted : null,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: isToday ? AppColors.primary : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              );
            }),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(7, (i) {
              final isToday = i == todayIndex;
              final dow = (selectedDate.weekday - 6 + i) % 7;
              return Text(
                _dayLabels[dow < 0 ? dow + 7 : dow],
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: isToday ? FontWeight.w800 : FontWeight.w500,
                  color: isToday ? AppColors.textMain : AppColors.textMuted,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

extension _MoodOptionEmoji on MoodOption {
  String get emoji => switch (this) {
    MoodOption.great => '🌟',
    MoodOption.good => '☀️',
    MoodOption.okay => '🍃',
    MoodOption.tired => '🌙',
    MoodOption.bad => '☁️',
  };
}
