import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_text_styles.dart';

class DailySectionHeader extends StatelessWidget {
  const DailySectionHeader({required this.title, super.key, this.action});

  final String title;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 5,
          height: 22,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(AppRadius.small),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(child: Text(title, style: AppTextStyles.sectionTitle)),
        ?action,
      ],
    );
  }
}
