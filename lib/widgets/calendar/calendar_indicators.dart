import 'package:flutter/material.dart';

import '../../models/mood_entry.dart';
import '../../theme/app_colors.dart';

class TaskCountBadge extends StatelessWidget {
  const TaskCountBadge({required this.count, super.key});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 11,
      height: 11,
      decoration: BoxDecoration(
        color: AppColors.yellow,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          '$count',
          style: TextStyle(
            fontSize: 6.5,
            fontWeight: FontWeight.w900,
            color: AppColors.ink,
            height: 1,
          ),
        ),
      ),
    );
  }
}

class CheckMark extends StatelessWidget {
  const CheckMark({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      '✓',
      style: TextStyle(
        fontSize: 9,
        fontWeight: FontWeight.w900,
        color: AppColors.mint,
      ),
    );
  }
}

class MoodEmoji extends StatelessWidget {
  const MoodEmoji({required this.mood, super.key});

  final MoodOption mood;

  static const _emojis = {
    MoodOption.great: '🌟',
    MoodOption.good: '☀️',
    MoodOption.okay: '🍃',
    MoodOption.tired: '🌙',
    MoodOption.bad: '☁️',
  };

  @override
  Widget build(BuildContext context) {
    return Text(_emojis[mood] ?? '', style: const TextStyle(fontSize: 8.5));
  }
}

class ExpenseLabel extends StatelessWidget {
  const ExpenseLabel({required this.total, required this.color, super.key});

  final String total;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      total,
      style: TextStyle(
        fontSize: 7,
        fontWeight: FontWeight.w700,
        color: color,
      ),
    );
  }
}

class EventBadge extends StatelessWidget {
  const EventBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 11,
      height: 11,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: .5),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          'E',
          style: TextStyle(
            fontSize: 6.5,
            fontWeight: FontWeight.w900,
            color: AppColors.ink,
            height: 1,
          ),
        ),
      ),
    );
  }
}
