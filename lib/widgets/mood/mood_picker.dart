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
        final moodColor = _colorFor(mood);

        return GestureDetector(
          onTap: () => onChanged(mood),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm + 4,
            ),
            decoration: BoxDecoration(
              color: selected
                  ? moodColor.withValues(alpha: .22)
                  : AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(
                color: selected ? moodColor : AppColors.border.withValues(alpha: .5),
                width: selected ? 2 : 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _emojiFor(mood),
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  mood.label,
                  style: TextStyle(
                    color: selected ? moodColor : AppColors.textMain,
                    fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Color _colorFor(MoodOption mood) {
    return switch (mood) {
      MoodOption.great => AppColors.yellow,
      MoodOption.good => AppColors.sky,
      MoodOption.okay => AppColors.sage,
      MoodOption.tired => AppColors.lavender,
      MoodOption.bad => AppColors.pink,
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
