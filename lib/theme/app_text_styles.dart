import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextStyle get title => TextStyle(
        color: AppColors.textMain,
        fontSize: 28,
        fontWeight: FontWeight.w900,
        letterSpacing: 0,
      );

  static TextStyle get sectionTitle => TextStyle(
        color: AppColors.textMain,
        fontSize: 16,
        fontWeight: FontWeight.w900,
        letterSpacing: 0,
      );

  static TextStyle get body => TextStyle(
        color: AppColors.textMain,
        fontSize: 15,
        fontWeight: FontWeight.w500,
      );

  static TextStyle get muted => TextStyle(
        color: AppColors.textMuted,
        fontSize: 13,
        fontWeight: FontWeight.w600,
      );
}
