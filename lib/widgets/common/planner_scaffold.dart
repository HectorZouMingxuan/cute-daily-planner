import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';

/// Consistent page wrapper that centers content and adds
/// a subtle gradient background for visual depth.
class PlannerScaffold extends StatelessWidget {
  const PlannerScaffold({
    required this.body,
    super.key,
    this.appBar,
    this.floatingActionButton,
    this.useGradient = true,
    this.maxContentWidth = 640,
  });

  final PreferredSizeWidget? appBar;
  final Widget body;
  final Widget? floatingActionButton;
  final bool useGradient;
  final double maxContentWidth;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: appBar,
      floatingActionButton: floatingActionButton,
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          if (useGradient) _PlannerGradient(isDark: isDark),
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxContentWidth),
                child: body,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlannerGradient extends StatelessWidget {
  const _PlannerGradient({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [
                    AppColors.primarySoft.withValues(alpha: .3),
                    AppColors.background,
                    AppColors.lavender.withValues(alpha: .08),
                  ]
                : [
                    AppColors.primarySoft.withValues(alpha: .4),
                    AppColors.background,
                    AppColors.sage.withValues(alpha: .12),
                  ],
            stops: const [0, .55, 1],
          ),
        ),
      ),
    );
  }
}

/// Convenience wrapper: PlannerScaffold with a ListView body and
/// standard screen padding.
class PlannerPage extends StatelessWidget {
  const PlannerPage({
    required this.children,
    super.key,
    this.appBar,
    this.floatingActionButton,
    this.padding = const EdgeInsets.all(AppSpacing.screenH),
    this.maxContentWidth = 640,
  });

  final PreferredSizeWidget? appBar;
  final List<Widget> children;
  final Widget? floatingActionButton;
  final EdgeInsetsGeometry padding;
  final double maxContentWidth;

  @override
  Widget build(BuildContext context) {
    return PlannerScaffold(
      appBar: appBar,
      floatingActionButton: floatingActionButton,
      maxContentWidth: maxContentWidth,
      body: ListView(
        padding: padding,
        children: children,
      ),
    );
  }
}
