import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({
    required this.icon,
    required this.title,
    required this.message,
    super.key,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: AppColors.primarySoft,
            child: Icon(icon, color: AppColors.primary, size: 30),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(title, style: AppTextStyles.sectionTitle),
          const SizedBox(height: AppSpacing.xs),
          Text(message, style: AppTextStyles.muted),
        ],
      ),
    );
  }
}
