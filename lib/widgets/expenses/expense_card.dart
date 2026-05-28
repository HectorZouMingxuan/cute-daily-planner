import 'package:flutter/material.dart';

import '../../models/expense_entry.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';

class ExpenseCard extends StatelessWidget {
  const ExpenseCard({required this.expense, required this.onTap, super.key});

  final ExpenseEntry expense;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isIncome = expense.type == ExpenseType.income;
    final sign = isIncome ? '+' : '-';

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.medium),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: isIncome
                    ? AppColors.mint.withValues(alpha: .45)
                    : AppColors.pink.withValues(alpha: .45),
                child: Icon(
                  isIncome
                      ? Icons.south_west_rounded
                      : Icons.north_east_rounded,
                  color: AppColors.textMain,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      expense.category.label,
                      style: const TextStyle(
                        color: AppColors.textMain,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      expense.note.isEmpty
                          ? expense.paymentMethod.label
                          : expense.note,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
              Text(
                '$sign${expense.amount.toStringAsFixed(2)}',
                style: TextStyle(
                  color: isIncome ? Colors.green.shade700 : AppColors.danger,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
