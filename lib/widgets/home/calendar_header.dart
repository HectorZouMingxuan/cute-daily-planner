import 'package:flutter/material.dart';

import '../../providers/calendar_view_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';

class CalendarHeader extends StatelessWidget {
  const CalendarHeader({
    required this.monthTitle,
    required this.monthlySummary,
    required this.calendarController,
    required this.onMonthTap,
    super.key,
  });

  final String monthTitle;
  final String? monthlySummary;
  final CalendarViewController calendarController;
  final VoidCallback onMonthTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: onMonthTap,
                child: Text(monthTitle, style: AppTextStyles.title),
              ),
            ),
            IconButton(
              tooltip: 'Previous month',
              onPressed: calendarController.goToPreviousMonth,
              icon: const Icon(Icons.chevron_left_rounded),
            ),
            IconButton(
              tooltip: 'Next month',
              onPressed: calendarController.goToNextMonth,
              icon: const Icon(Icons.chevron_right_rounded),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Align(
          alignment: Alignment.centerLeft,
          child: FilledButton.tonalIcon(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.ink,
            ),
            onPressed: calendarController.goToToday,
            icon: Icon(Icons.today_outlined),
            label: Text('Today'),
          ),
        ),
        if (monthlySummary != null) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(
            monthlySummary!,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textMuted,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
        const SizedBox(height: AppSpacing.md),
      ],
    );
  }
}
