import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTextStyles {
  const AppTextStyles._();

  static const title = TextStyle(
    color: AppColors.textMain,
    fontSize: 28,
    fontWeight: FontWeight.w900,
    letterSpacing: 0,
  );

  static const sectionTitle = TextStyle(
    color: AppColors.textMain,
    fontSize: 16,
    fontWeight: FontWeight.w900,
    letterSpacing: 0,
  );

  static const body = TextStyle(
    color: AppColors.textMain,
    fontSize: 15,
    fontWeight: FontWeight.w500,
  );

  static const muted = TextStyle(
    color: AppColors.textMuted,
    fontSize: 13,
    fontWeight: FontWeight.w600,
  );
}
