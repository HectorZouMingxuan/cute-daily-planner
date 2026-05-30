import 'dart:ui';

import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

class CalendarBackground extends StatelessWidget {
  const CalendarBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      children: [
        Positioned.fill(
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 1.2, sigmaY: 1.2),
            child: Image.asset(
              'assets/images/background.jpg',
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: isDark
                    ? [
                        AppColors.primarySoft.withValues(alpha: .82),
                        AppColors.primarySoft.withValues(alpha: .7),
                        AppColors.background.withValues(alpha: .85),
                      ]
                    : [
                        AppColors.primarySoft.withValues(alpha: .35),
                        AppColors.primarySoft.withValues(alpha: .25),
                        AppColors.background.withValues(alpha: .7),
                      ],
                stops: const [0, .4, 1],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
