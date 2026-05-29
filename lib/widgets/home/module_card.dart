import 'package:flutter/material.dart';

import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';
import '../common/soft_card.dart';

class ModuleCard extends StatelessWidget {
  const ModuleCard({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
    this.subtitle,
    super.key,
  });

  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(AppRadius.medium),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.medium),
        onTap: onTap,
        child: SoftCard(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: .2),
                  borderRadius: BorderRadius.circular(AppRadius.small),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(title, style: AppTextStyles.sectionTitle),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(subtitle!, style: AppTextStyles.muted),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
