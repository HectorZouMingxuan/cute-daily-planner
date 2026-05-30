import 'package:flutter/material.dart';

import '../../models/mood_entry.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../common/planner_card.dart';

/// At-a-glance daily snapshot shown between the calendar grid and
/// module cards on the home screen.
class DailySummaryCard extends StatelessWidget {
  const DailySummaryCard({
    required this.mood,
    required this.expenseNet,
    required this.taskDone,
    required this.taskTotal,
    required this.eventCount,
    required this.habitsChecked,
    required this.habitsTotal,
    super.key,
  });

  final MoodOption? mood;
  final double expenseNet;
  final int taskDone;
  final int taskTotal;
  final int eventCount;
  final int habitsChecked;
  final int habitsTotal;

  static const _emojis = {
    MoodOption.great: '🌟',
    MoodOption.good: '☀️',
    MoodOption.okay: '🍃',
    MoodOption.tired: '🌙',
    MoodOption.bad: '☁️',
  };

  String? _motivationalMessage() {
    if (taskTotal > 0 &&
        taskDone == taskTotal &&
        habitsTotal > 0 &&
        habitsChecked == habitsTotal) {
      return 'Perfect day! All tasks and habits complete ✨';
    }
    if (taskTotal > 0 && taskDone == taskTotal) {
      return 'All tasks done — great work today! 🎉';
    }
    if (mood == MoodOption.great || mood == MoodOption.good) {
      return 'Wonderful mood today! Keep that energy 🌈';
    }
    if (habitsTotal > 0 && habitsChecked >= habitsTotal) {
      return 'All habits checked in! You are consistent 💪';
    }
    if (taskTotal > 0 && taskDone > 0 && taskDone >= taskTotal / 2) {
      return 'More than halfway through your tasks! 🚀';
    }
    if (mood == MoodOption.tired || mood == MoodOption.bad) {
      return 'Take it easy — tomorrow is a fresh start 🌿';
    }
    if (taskTotal > 0 && taskDone == 0) {
      return 'A few tasks waiting — you got this! 💫';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (mood == null &&
        expenseNet == 0 &&
        taskTotal == 0 &&
        eventCount == 0 &&
        habitsTotal == 0) {
      return const SizedBox.shrink();
    }

    final message = _motivationalMessage();

    return PlannerCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.card,
        vertical: AppSpacing.sm + 4,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Stat chips row
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              if (mood != null)
                _Chip(
                  label: '${_emojis[mood]!} ${mood!.label}',
                  bgColor: AppColors.primarySoft,
                  textColor: AppColors.textMain,
                ),
              if (eventCount > 0)
                _Chip(
                  label: '$eventCount event${eventCount == 1 ? '' : 's'}',
                  bgColor: AppColors.primary.withValues(alpha: .15),
                  textColor: AppColors.primary,
                ),
              if (taskTotal > 0)
                _Chip(
                  label: taskDone == taskTotal
                      ? 'All tasks done ✅'
                      : '$taskDone/$taskTotal tasks',
                  bgColor: taskDone == taskTotal
                      ? AppColors.mint.withValues(alpha: .18)
                      : AppColors.sage.withValues(alpha: .22),
                  textColor: taskDone == taskTotal
                      ? AppColors.mint
                      : AppColors.textMain,
                ),
              if (expenseNet != 0) ...[
                _Chip(
                  label: '${expenseNet > 0 ? "+" : ""}${expenseNet.toStringAsFixed(0)}',
                  bgColor: (expenseNet > 0 ? AppColors.mint : AppColors.danger)
                      .withValues(alpha: .18),
                  textColor:
                      expenseNet > 0 ? AppColors.mint : AppColors.danger,
                ),
              ],
              if (habitsTotal > 0)
                _Chip(
                  label: '$habitsChecked/$habitsTotal habits',
                  bgColor: AppColors.mint.withValues(alpha: .18),
                  textColor: AppColors.mint,
                ),
            ],
          ),
          // Motivational message
          if (message != null) ...[
            const SizedBox(height: AppSpacing.sm + 2),
            Text(
              message,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textMuted,
                height: 1.35,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.bgColor,
    required this.textColor,
  });

  final String label;
  final Color bgColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: textColor,
          height: 1.2,
        ),
      ),
    );
  }
}
