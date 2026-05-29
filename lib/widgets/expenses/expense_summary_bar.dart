import 'package:flutter/material.dart';

import '../../models/expense_entry.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';

class ExpenseSummaryBar extends StatelessWidget {
  const ExpenseSummaryBar({required this.expenses, required this.selectedDate, super.key});

  final List<ExpenseEntry> expenses;
  final DateTime selectedDate;

  @override
  Widget build(BuildContext context) {
    final dailyTotals = List.generate(7, (i) {
      final day = selectedDate.subtract(Duration(days: 6 - i));
      return expenses
          .where((e) =>
              e.date.year == day.year &&
              e.date.month == day.month &&
              e.date.day == day.day)
          .fold<double>(0, (sum, e) => e.type == ExpenseType.income ? sum + e.amount : sum - e.amount);
    });

    final hasData = dailyTotals.any((n) => n != 0);
    if (!hasData) return const SizedBox.shrink();

    final maxAbs = dailyTotals.map((n) => n.abs()).reduce((a, b) => a > b ? a : b);
    final todayIndex = 6;
    final labels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    return Container(
      margin: const EdgeInsets.only(top: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.primarySoft.withValues(alpha: .35),
        borderRadius: BorderRadius.circular(AppRadius.small),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(7, (i) {
              final net = dailyTotals[i];
              final barHeight = maxAbs == 0 ? 1.0 : (net.abs() / maxAbs) * 32;
              final isToday = i == todayIndex;
              final color = net > 0 ? AppColors.mint : AppColors.danger;
              final dow = (selectedDate.weekday - 6 + i) % 7;
              final dowLabel = labels[dow < 0 ? dow + 7 : dow];

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    net == 0 ? '·' : '${net > 0 ? "+" : ""}${net.toStringAsFixed(0)}',
                    style: TextStyle(fontSize: 8, fontWeight: FontWeight.w700, color: net == 0 ? AppColors.textMuted : color),
                  ),
                  const SizedBox(height: 2),
                  Container(
                    width: 18,
                    height: barHeight < 2 ? 2 : barHeight,
                    decoration: BoxDecoration(
                      color: net == 0 ? AppColors.border : color.withValues(alpha: .7),
                      borderRadius: BorderRadius.vertical(top: Radius.circular(2)),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dowLabel,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: isToday ? FontWeight.w800 : FontWeight.w500,
                      color: isToday ? AppColors.textMain : AppColors.textMuted,
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
