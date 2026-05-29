import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../common/soft_card.dart';

class DailySummaryCard extends StatelessWidget {
  const DailySummaryCard({
    required this.moodLabel,
    required this.expenseNet,
    required this.taskDone,
    required this.taskTotal,
    required this.eventCount,
    required this.habitsChecked,
    required this.habitsTotal,
    super.key,
  });

  final String? moodLabel;
  final double expenseNet;
  final int taskDone;
  final int taskTotal;
  final int eventCount;
  final int habitsChecked;
  final int habitsTotal;

  String? _motivationalMessage() {
    if (taskTotal > 0 && taskDone == taskTotal && habitsTotal > 0 && habitsChecked == habitsTotal) {
      return 'Perfect day! All tasks and habits complete';
    }
    if (taskTotal > 0 && taskDone == taskTotal) {
      return 'All tasks done — great work today!';
    }
    if (moodLabel == 'Great' || moodLabel == 'Good') {
      return 'Wonderful mood today! Keep that energy';
    }
    if (habitsTotal > 0 && habitsChecked >= habitsTotal) {
      return 'All habits checked in! You are consistent';
    }
    if (taskTotal > 0 && taskDone > 0 && taskDone >= taskTotal / 2) {
      return 'More than halfway through your tasks!';
    }
    if (moodLabel == 'Tired' || moodLabel == 'Bad') {
      return 'Take it easy — tomorrow is a fresh start';
    }
    if (taskTotal > 0 && taskDone == 0) {
      return 'A few tasks waiting — you got this!';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (moodLabel == null &&
        expenseNet == 0 &&
        taskTotal == 0 &&
        eventCount == 0 &&
        habitsTotal == 0) {
      return const SizedBox.shrink();
    }

    final message = _motivationalMessage();

    return SoftCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm + 4,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (moodLabel != null) _StatChip(label: moodLabel!),
              if (eventCount > 0)
                _StatChip(label: '$eventCount event${eventCount == 1 ? '' : 's'}'),
              if (taskTotal > 0)
                _StatChip(
                  label: taskDone == taskTotal
                      ? 'All done'
                      : '$taskDone/$taskTotal',
                  icon: taskDone == taskTotal
                      ? const Icon(Icons.check_circle, size: 14, color: AppColors.mint)
                      : null,
                ),
              if (expenseNet != 0) _ExpenseStatChip(net: expenseNet),
              if (habitsTotal > 0)
                _StatChip(label: '$habitsChecked/$habitsTotal habits'),
            ],
          ),
          if (message != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              message,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.textMuted,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({required this.label, this.icon});

  final String label;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primarySoft.withValues(alpha: .5),
        borderRadius: BorderRadius.circular(AppRadius.small),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[icon!, const SizedBox(width: 4)],
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.textMain,
            ),
          ),
        ],
      ),
    );
  }
}

class _ExpenseStatChip extends StatelessWidget {
  const _ExpenseStatChip({required this.net});

  final double net;

  @override
  Widget build(BuildContext context) {
    final isIncome = net > 0;
    final sign = isIncome ? '+' : '';
    final color = isIncome ? AppColors.mint : AppColors.danger;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .15),
        borderRadius: BorderRadius.circular(AppRadius.small),
      ),
      child: Text(
        '$sign${net.toStringAsFixed(0)}',
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: color),
      ),
    );
  }
}
