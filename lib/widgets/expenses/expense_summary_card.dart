import 'package:flutter/material.dart';

import '../../models/expense_entry.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../common/soft_card.dart';

class ExpenseSummaryCard extends StatelessWidget {
  const ExpenseSummaryCard({required this.expenses, super.key});

  final List<ExpenseEntry> expenses;

  @override
  Widget build(BuildContext context) {
    final spent = expenses
        .where((entry) => entry.type == ExpenseType.expense)
        .fold<double>(0, (sum, entry) => sum + entry.amount);
    final income = expenses
        .where((entry) => entry.type == ExpenseType.income)
        .fold<double>(0, (sum, entry) => sum + entry.amount);
    final balance = income - spent;

    return SoftCard(
      child: Row(
        children: [
          _SummaryItem(
            label: 'Spent Today',
            value: spent,
            color: AppColors.pink,
          ),
          const SizedBox(width: AppSpacing.sm),
          _SummaryItem(
            label: 'Income Today',
            value: income,
            color: AppColors.mint,
          ),
          const SizedBox(width: AppSpacing.sm),
          _SummaryItem(
            label: 'Balance',
            value: balance,
            color: AppColors.primary,
          ),
        ],
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  const _SummaryItem({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final double value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: color.withValues(alpha: .35),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.textMuted,
                fontWeight: FontWeight.w700,
                fontSize: 11,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              value.toStringAsFixed(2),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.textMain,
                fontWeight: FontWeight.w900,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
