import 'package:flutter/material.dart';

import '../../providers/calendar_view_provider.dart';
import '../../theme/app_colors.dart';

Future<void> showMonthPickerDialog(
  BuildContext context,
  DateTime focusedDay,
  CalendarViewController controller,
) {
  final months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];
  var year = focusedDay.year;

  return showDialog(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setDialogState) => AlertDialog(
        title: Row(
          children: [
            GestureDetector(
              onTap: () => setDialogState(() => year--),
              child: const Icon(Icons.chevron_left_rounded),
            ),
            Expanded(
              child: Text('$year', textAlign: TextAlign.center),
            ),
            GestureDetector(
              onTap: () => setDialogState(() => year++),
              child: const Icon(Icons.chevron_right_rounded),
            ),
          ],
        ),
        content: SizedBox(
          width: 280,
          child: Wrap(
            spacing: 4,
            runSpacing: 4,
            children: List.generate(12, (i) {
              final isCurrent = i == focusedDay.month - 1 && year == focusedDay.year;
              return SizedBox(
                width: 64,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: isCurrent
                        ? AppColors.primary.withValues(alpha: .35)
                        : null,
                  ),
                  onPressed: () {
                    controller.goToMonth(DateTime(year, i + 1));
                    Navigator.pop(ctx);
                  },
                  child: Text(months[i]),
                ),
              );
            }),
          ),
        ),
      ),
    ),
  );
}
