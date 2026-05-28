import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';

class DailyTabBar extends StatelessWidget {
  const DailyTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.ink.withValues(alpha: .68),
        borderRadius: BorderRadius.circular(AppRadius.large),
        border: Border.all(color: AppColors.primary.withValues(alpha: .35)),
      ),
      child: TabBar(
        dividerColor: Colors.transparent,
        indicator: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(AppRadius.medium),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: AppColors.ink,
        unselectedLabelColor: Colors.white70,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 13,
          letterSpacing: 0,
        ),
        tabs: const [
          Tab(text: 'Plan'),
          Tab(text: 'Money'),
          Tab(text: 'Tasks'),
          Tab(text: 'Notes'),
        ],
      ),
    );
  }
}
