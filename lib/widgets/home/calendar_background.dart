import 'dart:ui';

import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

class CalendarBackground extends StatelessWidget {
  const CalendarBackground({super.key});

  @override
  Widget build(BuildContext context) {
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
            decoration: BoxDecoration(color: AppColors.backgroundOverlay),
          ),
        ),
      ],
    );
  }
}
