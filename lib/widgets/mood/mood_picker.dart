import 'package:flutter/material.dart';

import '../../models/mood_entry.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';

class MoodPicker extends StatelessWidget {
  const MoodPicker({
    required this.selectedMood,
    required this.onChanged,
    super.key,
  });

  final MoodOption? selectedMood;
  final ValueChanged<MoodOption> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: MoodOption.values.map((mood) {
        final selected = selectedMood == mood;
        return ChoiceChip(
          label: Text('${_emojiFor(mood)}  ${mood.label}'),
          selected: selected,
          avatar: Icon(_iconFor(mood), size: 16),
          selectedColor: AppColors.lavender.withValues(alpha: .55),
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.medium),
            side: BorderSide(
              color: selected ? AppColors.lavender : AppColors.border,
            ),
          ),
          onSelected: (_) => onChanged(mood),
        );
      }).toList(),
    );
  }

  IconData _iconFor(MoodOption mood) {
    return switch (mood) {
      MoodOption.great => Icons.star_rounded,
      MoodOption.good => Icons.wb_sunny_outlined,
      MoodOption.okay => Icons.eco_outlined,
      MoodOption.tired => Icons.nights_stay_outlined,
      MoodOption.bad => Icons.cloud_outlined,
    };
  }

  String _emojiFor(MoodOption mood) {
    return switch (mood) {
      MoodOption.great => '🌟',
      MoodOption.good => '☀️',
      MoodOption.okay => '🍃',
      MoodOption.tired => '🌙',
      MoodOption.bad => '☁️',
    };
  }
}
