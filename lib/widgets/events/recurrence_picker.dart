import 'package:flutter/material.dart';

import '../../models/recurrence_rule.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';

class RecurrencePicker extends StatelessWidget {
  const RecurrencePicker({
    required this.selectedRule,
    required this.onChanged,
    super.key,
  });

  final RecurrenceRule selectedRule;
  final ValueChanged<RecurrenceRule> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Repeat', style: AppTextStyles.body),
        const SizedBox(height: AppSpacing.sm),
        DropdownButtonFormField<RecurrenceFrequency>(
          initialValue: selectedRule.frequency,
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.repeat_rounded),
          ),
          items: RecurrenceFrequency.values
              .map(
                (frequency) => DropdownMenuItem(
                  value: frequency,
                  child: Text(RecurrenceRule(frequency: frequency).label),
                ),
              )
              .toList(),
          onChanged: (frequency) {
            if (frequency != null) {
              onChanged(RecurrenceRule(frequency: frequency));
            }
          },
        ),
      ],
    );
  }
}
