import 'dart:ui';

import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';

/// The primary card surface used everywhere in the planner.
///
/// Provides the signature soft-glass look with blur and a subtle
/// colored border that adapts to the current theme.
class PlannerCard extends StatelessWidget {
  const PlannerCard({
    required this.child,
    super.key,
    this.padding = const EdgeInsets.all(AppSpacing.card),
    this.onTap,
    this.color,
    this.borderColor,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Color? color;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final card = ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: color ?? AppColors.surface.withValues(alpha: isDark ? .78 : .72),
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(
              color: borderColor ??
                  AppColors.border.withValues(alpha: isDark ? .35 : .48),
            ),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withValues(alpha: .35)
                    : const Color(0xFF3A3020).withValues(alpha: .06),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Padding(padding: padding, child: child),
        ),
      ),
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.md),
          onTap: onTap,
          child: card,
        ),
      );
    }

    return card;
  }
}

// Keep SoftCard as an alias for backward compatibility.
typedef SoftCard = PlannerCard;
